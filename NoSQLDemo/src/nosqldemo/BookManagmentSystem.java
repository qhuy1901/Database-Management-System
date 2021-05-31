package nosqldemo;

import com.mongodb.*;
import java.awt.Component;
import java.net.UnknownHostException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumnModel;

public class BookManagmentSystem extends javax.swing.JFrame {

    DB db;
    DBCollection bookCollection;
    Mongo mg = null;
    DBCursor cursor = null;
    
    public BookManagmentSystem() 
    {
        initComponents();
        resizeColumnWidth(tblBookInformation);
        setLocationRelativeTo(null);
        try {
            // Connect to MongoDB 
            Mongo mg = new Mongo("localhost", 27017);
            db = mg.getDB("BookManagementSystem");
            bookCollection = db.getCollection("Book");
            System.out.println("Successful connection.");
            
            creatTable();
        } catch (UnknownHostException ex) {
             System.out.println("Connection failed.");
            Logger.getLogger(BookManagmentSystem.class.getName()).log(Level.SEVERE, null, ex);
        }
        setVisible(true);
    }

    DefaultTableModel tblBookModel = null;
    public void creatTable()
    {
        cursor = bookCollection.find();

        String[] title = {"Book name", "Author", "Publisher", "Price"};
        tblBookModel = new DefaultTableModel(title, 0);

        while(cursor.hasNext()) {
            DBObject obj = cursor.next();
            String name = (String)obj.get("name");
            String publisher = (String)obj.get("publisher");
            String author = (String)obj.get("author");
            String price = String.valueOf(obj.get("price"));
            
            //ObjectId id = (ObjectId)obj.get("_id");
            tblBookModel.addRow(new Object[] { name, author, publisher, price});
        }
        tblBookInformation.setModel(tblBookModel);
        cursor.close(); 
    }
    
    public void clearForm()
    {
        txtBookName.setText("");
        txtAuthor.setText("");
        txtPublisher.setText("");
        txtPrice.setText("");
        creatTable();
    }
    
    public void resizeColumnWidth(JTable table) 
    {
        final TableColumnModel columnModel = table.getColumnModel();
        for (int column = 0; column < table.getColumnCount(); column++) 
        {
            int width = 15; // Min width
            for (int row = 0; row < table.getRowCount(); row++) 
            {
                TableCellRenderer renderer = table.getCellRenderer(row, column);
                Component comp = table.prepareRenderer(renderer, row, column);
                width = Math.max(comp.getPreferredSize().width + 1 , width);
            }
            if(width > 300)
                width = 300;
            columnModel.getColumn(column).setPreferredWidth(width);
        }
    }
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        lblTacGia = new javax.swing.JLabel();
        lblNhaXuatBan = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        tblBookInformation = new javax.swing.JTable();
        btnExit = new javax.swing.JButton();
        txtPrice = new javax.swing.JTextField();
        txtBookName = new javax.swing.JTextField();
        lbTenSach = new javax.swing.JLabel();
        txtAuthor = new javax.swing.JTextField();
        lblBookManagement = new javax.swing.JLabel();
        txtPublisher = new javax.swing.JTextField();
        lblGia = new javax.swing.JLabel();
        btnAdd = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        btnUpdate = new javax.swing.JButton();
        btnDelete = new javax.swing.JButton();
        btnClear = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Book Management System");
        setBackground(new java.awt.Color(239, 250, 252));
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        lblTacGia.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        lblTacGia.setText("Author");
        getContentPane().add(lblTacGia, new org.netbeans.lib.awtextra.AbsoluteConstraints(478, 69, 88, 43));

        lblNhaXuatBan.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        lblNhaXuatBan.setText("Publisher");
        getContentPane().add(lblNhaXuatBan, new org.netbeans.lib.awtextra.AbsoluteConstraints(478, 118, 109, 43));

        tblBookInformation.setFont(new java.awt.Font("Segoe UI", 0, 13)); // NOI18N
        tblBookInformation.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        tblBookInformation.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                tblBookInformationMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(tblBookInformation);

        getContentPane().add(jScrollPane1, new org.netbeans.lib.awtextra.AbsoluteConstraints(58, 179, 770, 226));

        btnExit.setBackground(new java.awt.Color(255, 255, 255));
        btnExit.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        btnExit.setText("Exit");
        btnExit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnExitActionPerformed(evt);
            }
        });
        getContentPane().add(btnExit, new org.netbeans.lib.awtextra.AbsoluteConstraints(708, 438, 120, 31));
        getContentPane().add(txtPrice, new org.netbeans.lib.awtextra.AbsoluteConstraints(174, 127, 235, 30));
        getContentPane().add(txtBookName, new org.netbeans.lib.awtextra.AbsoluteConstraints(174, 78, 235, 30));

        lbTenSach.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        lbTenSach.setText("Book Name");
        getContentPane().add(lbTenSach, new org.netbeans.lib.awtextra.AbsoluteConstraints(58, 69, 106, 43));
        getContentPane().add(txtAuthor, new org.netbeans.lib.awtextra.AbsoluteConstraints(591, 78, 235, 30));

        lblBookManagement.setBackground(new java.awt.Color(32, 172, 210));
        lblBookManagement.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        lblBookManagement.setText("Book Management");
        getContentPane().add(lblBookManagement, new org.netbeans.lib.awtextra.AbsoluteConstraints(345, 10, 225, 43));
        getContentPane().add(txtPublisher, new org.netbeans.lib.awtextra.AbsoluteConstraints(591, 127, 235, 30));

        lblGia.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        lblGia.setText("Price");
        getContentPane().add(lblGia, new org.netbeans.lib.awtextra.AbsoluteConstraints(58, 118, 88, 43));

        btnAdd.setBackground(new java.awt.Color(255, 255, 255));
        btnAdd.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        btnAdd.setText("Add Book");
        btnAdd.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnAddActionPerformed(evt);
            }
        });
        getContentPane().add(btnAdd, new org.netbeans.lib.awtextra.AbsoluteConstraints(58, 438, 150, 31));

        jPanel1.setBackground(new java.awt.Color(239, 250, 252));

        btnUpdate.setBackground(new java.awt.Color(255, 255, 255));
        btnUpdate.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        btnUpdate.setText("Update Book Information");
        btnUpdate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnUpdateActionPerformed(evt);
            }
        });

        btnDelete.setBackground(new java.awt.Color(255, 255, 255));
        btnDelete.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        btnDelete.setText("Delete Book");
        btnDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnDeleteActionPerformed(evt);
            }
        });

        btnClear.setBackground(new java.awt.Color(255, 255, 255));
        btnClear.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        btnClear.setText("Clear Form");
        btnClear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnClearActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap(221, Short.MAX_VALUE)
                .addComponent(btnDelete, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(btnUpdate, javax.swing.GroupLayout.PREFERRED_SIZE, 196, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(btnClear, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(183, 183, 183))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap(438, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(btnUpdate, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnDelete, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnClear, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(31, 31, 31))
        );

        getContentPane().add(jPanel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 880, 500));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnUpdateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUpdateActionPerformed
        int indexTB = tblBookInformation.getSelectedRow();
        
        if(indexTB < tblBookModel.getRowCount() && indexTB >= 0)
        {
            int ret = JOptionPane.showConfirmDialog(null, "Are you sure to update this book's information?", "Confirm", JOptionPane.YES_NO_OPTION);
            if(ret == JOptionPane.YES_OPTION)
            {
                BasicDBObject oldDocument = new BasicDBObject();
                oldDocument.append("name", tblBookInformation.getValueAt(indexTB, 0).toString());
                
                BasicDBObject newDocument = new BasicDBObject();
                newDocument.put("name", txtBookName.getText());
                newDocument.put("author", txtAuthor.getText());
                newDocument.put("publisher", txtPublisher.getText());
                newDocument.put("price", Integer.parseInt(txtPrice.getText()));
                bookCollection.update(oldDocument , newDocument);
                clearForm();
                JOptionPane.showConfirmDialog(null, "Book updated successfully...", "Notification", JOptionPane.CLOSED_OPTION);
            }
        }
    }//GEN-LAST:event_btnUpdateActionPerformed
    
    private void btnClearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnClearActionPerformed
        clearForm();
    }//GEN-LAST:event_btnClearActionPerformed

    private void btnExitActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnExitActionPerformed
        int ret = JOptionPane.showConfirmDialog(null , "Are you sure to exit?", "Exit", JOptionPane.YES_NO_OPTION);
        if(ret == JOptionPane.YES_OPTION)
            System.exit(0);

    }//GEN-LAST:event_btnExitActionPerformed

    private void btnDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnDeleteActionPerformed
        int indexTB = tblBookInformation.getSelectedRow();
        
        if(indexTB < tblBookModel.getRowCount() && indexTB >= 0)
        {
            int ret = JOptionPane.showConfirmDialog(null, "Are you sure to delete this book's information?", "Confirm", JOptionPane.YES_NO_OPTION);
            if(ret == JOptionPane.YES_OPTION)
            {
                BasicDBObject document = new BasicDBObject();
                document.append("name", tblBookInformation.getValueAt(indexTB, 0).toString());
                bookCollection.remove(document);
                clearForm();
                JOptionPane.showConfirmDialog(null, "Book deleted successfully...", "Notification", JOptionPane.CLOSED_OPTION);
            }
        }
    }//GEN-LAST:event_btnDeleteActionPerformed

    private void btnAddActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnAddActionPerformed
        // TODO add your handling code here:
        if(txtBookName.getText().equals("") || txtAuthor.getText().equals("") || txtPublisher.getText().equals("") || txtPrice.getText().equals(""))
        {
            JOptionPane.showConfirmDialog(null, "Vui lòng nhập đầy đủ thông tin", "OK", JOptionPane.CLOSED_OPTION);
        }
        else
        {
            BasicDBObject document = new BasicDBObject();
            document.put("name", txtBookName.getText());
            document.put("author", txtAuthor.getText());
            document.put("publisher", txtPublisher.getText());
            document.put("price", Integer.parseInt(txtPrice.getText()));
            bookCollection.insert(document);
            JOptionPane.showConfirmDialog(null, "Book added successfully...", "Notification", JOptionPane.CLOSED_OPTION);
            clearForm();
        }
    }//GEN-LAST:event_btnAddActionPerformed

    private void tblBookInformationMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_tblBookInformationMouseClicked
        int indexTB = tblBookInformation.getSelectedRow();
        
        if(indexTB < tblBookModel.getRowCount() && indexTB >= 0)
        {
            txtBookName.setText(tblBookModel.getValueAt(indexTB, 0).toString());
            txtAuthor.setText(tblBookModel.getValueAt(indexTB, 1).toString());
            txtPublisher.setText(tblBookModel.getValueAt(indexTB, 2).toString());
            txtPrice.setText(tblBookModel.getValueAt(indexTB, 3).toString());
        }
    }//GEN-LAST:event_tblBookInformationMouseClicked


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnAdd;
    private javax.swing.JButton btnClear;
    private javax.swing.JButton btnDelete;
    private javax.swing.JButton btnExit;
    private javax.swing.JButton btnTim;
    private javax.swing.JButton btnUpdate;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JLabel lbTenSach;
    private javax.swing.JLabel lblBookManagement;
    private javax.swing.JLabel lblGia;
    private javax.swing.JLabel lblNhaXuatBan;
    private javax.swing.JLabel lblTacGia;
    private javax.swing.JTable tblBookInformation;
    private javax.swing.JTextField txtAuthor;
    private javax.swing.JTextField txtBookName;
    private javax.swing.JTextField txtPrice;
    private javax.swing.JTextField txtPublisher;
    // End of variables declaration//GEN-END:variables
}
