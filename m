From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Wed, 28 Apr 2010 18:54:49 +0530
Message-ID: <201004281854.49730.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Eelis <opensuse.org@contacts.eelis.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Prevent creation of files larger than RLIMIT_FSIZE using fallocate.

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a file larger than the limit. Add a check for new size in
the fallocate system call.

File-systems supporting fallocate such as ext4 are affected by this
bug. 

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Reported-by: Eelis - <opensuse.org@contacts.eelis.net>

---

diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..95ce069 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -412,10 +412,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 		return -ENODEV;
 
-	/* Check for wrap through zero too */
-	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
+	/* Check for wrap through zero */
+	if (offset+len < 0)
 		return -EFBIG;
 
+	ret = inode_newsize_ok(inode, (offset + len));
+	if (ret)
+		return ret;
+
 	if (!inode->i_op->fallocate)
 		return -EOPNOTSUPP;
 
