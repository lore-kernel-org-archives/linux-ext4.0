From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: debugfs: fix debugfs dump for a hashed directory
Date: Tue, 14 Jul 2015 15:33:14 +0300
Message-ID: <5398A7F7-DB88-4604-9ED5-96FF262117EC@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33326 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbbGNMdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2015 08:33:25 -0400
Received: by qkdy129 with SMTP id y129so567444qkd.0
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2015 05:33:25 -0700 (PDT)
Received: from c-46-246-9-239.ip4.frootvpn.com ([46.246.9.239])
        by smtp.gmail.com with ESMTPSA id n6sm379883qhb.16.2015.07.14.05.33.23
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 14 Jul 2015 05:33:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

debugfs produce wrong output for a htree command in some cases.
sync a htree structures with in kernel implementation.

---
 debugfs/htree.c      |  6 +++---
 lib/ext2fs/ext2_fs.h | 14 ++++++++++++++
 lib/ext2fs/ext2fs.h  |  2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 24f8250..d47793a 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -185,7 +185,7 @@ static void htree_dump_int_block(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	htree_dump_int_node(fs, ino, inode, rootnode,
-			    (struct ext2_dx_entry *) (buf+8),
+			    ((struct ext2_dx_node *)buf)->entries,
 			    cbuf, level);
 errout:
 	free(cbuf);
@@ -244,7 +244,7 @@ void do_htree_dump(int argc, char *argv[])
 		goto errout;
 	}
 
-	rootnode = (struct ext2_dx_root_info *) (buf + 24);
+	rootnode = get_ext2_dx_root_info(current_fs, buf);
 
 	fprintf(pager, "Root node dump:\n");
 	fprintf(pager, "\t Reserved zero: %u\n", rootnode->reserved_zero);
@@ -253,7 +253,7 @@ void do_htree_dump(int argc, char *argv[])
 	fprintf(pager, "\t Indirect levels: %d\n", rootnode->indirect_levels);
 	fprintf(pager, "\t Flags: %d\n", rootnode->unused_flags);
 
-	ent = (struct ext2_dx_entry *) (buf + 24 + rootnode->info_length);
+	ent = (struct ext2_dx_entry *) ((char *)rootnode + rootnode->info_length);
 
 	htree_dump_int_node(current_fs, ino, &inode, rootnode, ent,
 			    buf + current_fs->blocksize,
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 8965f4c..d1397db 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -235,6 +235,20 @@ struct ext2_dx_countlimit {
 	__u16 count;
 };
 
+struct fake_dirent
+{
+	__u32 inode;
+	__u16 rec_len;
+	__u8 name_len;
+	__u8 file_type;
+};
+
+struct ext2_dx_node
+{
+	struct fake_dirent fake;
+	struct ext2_dx_entry	entries[0];
+};
+
 
 /*
  * Macro-instructions used to manage group descriptors

