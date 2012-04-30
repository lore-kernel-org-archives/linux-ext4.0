From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3 V2] vfs: allow custom EOF in generic_file_llseek code
Date: Mon, 30 Apr 2012 13:11:29 -0500
Message-ID: <4F9ED5D1.2080707@redhat.com>
References: <4F9AC770.8080004@redhat.com> <20120428183315.GA28349@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120428183315.GA28349@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For ext3/4 htree directories, using the vfs llseek function with
SEEK_END goes to i_size like for any other file, but in reality
we want the maximum possible hash value.  Recent changes
in ext4 have cut & pasted generic_file_llseek() back into fs/ext4/dir.c,
but replicating this core code seems like a bad idea, especially
since the copy has already diverged from the vfs.

This patch updates generic_file_llseek_size to accept
both a custom maximum offset, and a custom EOF position.  With this
in place, ext4_dir_llseek can pass in the appropriate maximum hash
position for both maxsize and eof, and get what it wants.

As far as I know, this does not fix any bugs - nfs in the kernel
doesn't use SEEK_END, and I don't know of any user who does.  But
some ext4 folks seem keen on doing the right thing here, and I can't
really argue.

(Patch also fixes up some comments slightly)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Just add a new argument to the existing generic_file_llseek_size()
function, per Matthew Wilcox's suggestion.

diff --git a/fs/read_write.c b/fs/read_write.c
index ffc99d2..e840d01 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -55,10 +55,11 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
  * @origin:	type of seek
- * @size:	max size of file system
+ * @size:	max size of this file in file system
+ * @eof:	offset used for SEEK_END position
  *
  * This is a variant of generic_file_llseek that allows passing in a custom
- * file size.
+ * maximum file size and a custom EOF position, for e.g. hashed directories
  *
  * Synchronization:
  * SEEK_SET and SEEK_END are unsynchronized (but atomic on 64bit platforms)
@@ -67,13 +68,13 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
  */
 loff_t
 generic_file_llseek_size(struct file *file, loff_t offset, int origin,
-		loff_t maxsize)
+		loff_t maxsize, loff_t eof)
 {
 	struct inode *inode = file->f_mapping->host;
 
 	switch (origin) {
 	case SEEK_END:
-		offset += i_size_read(inode);
+		offset += eof;
 		break;
 	case SEEK_CUR:
 		/*
@@ -99,7 +100,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
 		 * In the generic case the entire file is data, so as long as
 		 * offset isn't at the end of the file then the offset is data.
 		 */
-		if (offset >= i_size_read(inode))
+		if (offset >= eof)
 			return -ENXIO;
 		break;
 	case SEEK_HOLE:
@@ -107,9 +108,9 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= i_size_read(inode))
+		if (offset >= eof)
 			return -ENXIO;
-		offset = i_size_read(inode);
+		offset = eof;
 		break;
 	}
 
@@ -132,7 +133,8 @@ loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 	struct inode *inode = file->f_mapping->host;
 
 	return generic_file_llseek_size(file, offset, origin,
-					inode->i_sb->s_maxbytes);
+					inode->i_sb->s_maxbytes,
+					i_size_read(inode));
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..4ba8215 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2401,7 +2401,7 @@ extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
-		int origin, loff_t maxsize);
+		int origin, loff_t maxsize, loff_t eof);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 


