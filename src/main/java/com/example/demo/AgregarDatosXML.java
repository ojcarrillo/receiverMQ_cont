package com.example.demo;

import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.EnumSet;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * Permite manejar los mensajes recibidos y los agrega a los archivos de transacciones
 * @author Administrador
 *
 */
@Component
public class AgregarDatosXML {
	
	private static final Logger log = LoggerFactory.getLogger(AgregarDatosXML.class);
	
	private final static String PATH = File.separator + "ftp" + File.separator + "touresbalon" + File.separator + "serv_contabilidad" + File.separator;
	private final static String BILL = "bill.txt";
	private final static String INVOICE = "invoice.txt";
	private final static String RECEIPTS = "recepits.txt";
	private static final String ENDLINE = "\r\n";
	
	public void aggregarAlXML(String msg) {
		/* primer caracter determina el tipo de transaccion B,I,R */
		String opc = msg.substring(0, 1);
		String msgAdd = msg.substring(1, 51); 
		String fileName = null;
		/* arma el nombre del archivo para agregar el mensaje */
		if("B".equals(opc)) {
			/* Bills */
			fileName = BILL;
		}else if("I".equals(opc)) {
			/* Invoice */
			fileName = INVOICE;
		}else if("R".equals(opc)) {
			/* Recepit */
			fileName = RECEIPTS;
		}
		/* agrega la transaccion al archivo correspondiente */
		try {
			if(fileName!=null) {
				aggMsg(msgAdd, PATH + fileName);
			} else {
				log.error("=============> formato no valido!!!");
			}
		}
		catch (Exception e) {
			log.error("=============> error de escritura!!! "+e.getMessage());
			e.printStackTrace();
		}
	}
	
	public void aggMsg(String msgAdd, String fileName) throws IOException {
		File file = new File(fileName);
		/* valida si existe el archivo, sino lo crea */
		if(!file.exists()) {			
			file.getParentFile().mkdirs();
			file.createNewFile(); 
			Set<PosixFilePermission> permissions = PosixFilePermissions.fromString("rw-rw-rw-");
		    FileAttribute<Set<PosixFilePermission>> fileAttributes = PosixFilePermissions
		        .asFileAttribute(permissions);
		    Files.setPosixFilePermissions(Paths.get(file.getPath()), permissions);			
		}
		/* agrega el nuevo mensaje al archivo */
		try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(fileName), StandardOpenOption.APPEND)) {
		    writer.write(msgAdd + ENDLINE);
		    writer.close();
		} catch (IOException ioe) {
		    log.error("IOException: %s%n", ioe);
		}
		log.info(">>> dato agregado a "+fileName);
	}

}
