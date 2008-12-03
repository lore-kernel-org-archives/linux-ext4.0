From: Greg KH <gregkh@suse.de>
Subject: [patch 083/104] ext4: elevate write count for migrate ioctl
Date: Wed, 3 Dec 2008 11:56:12 -0800
Message-ID: <20081203195612.GF8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755288AbYLCT5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:46 -0500
Content-Disposition: inline; filename="ext4-elevate-write-count-for-migrate-ioctl.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 2a43a878001cc5cb7c3c7be2e8dad0a1aeb939b0)

The migrate ioctl writes to the filsystem, so we need to elevate the
write count.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h    |    3 +--
 fs/ext4/ioctl.c   |   21 ++++++++++++++++++++-
 fs/ext4/migrate.c |   10 +---------
 3 files changed, 22 insertions(+), 12 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1083,8 +1083,7 @@ extern long ext4_ioctl(struct file *, un
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* migrate.c */
-extern int ext4_ext_migrate(struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern int ext4_ext_migrate(struct inode *);
 /* namei.c */
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -267,7 +267,26 @@ setversion_out:
 	}
 
 	case EXT4_IOC_MIGRATE:
-		return ext4_ext_migrate(inode, filp, cmd, arg);
+	{
+		int err;
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			return err;
+		/*
+		 * inode_mutex prevent write and truncate on the file.
+		 * Read still goes through. We take i_data_sem in
+		 * ext4_ext_swap_inode_data before we switch the
+		 * inode format to prevent read.
+		 */
+		mutex_lock(&(inode->i_mutex));
+		err = ext4_ext_migrate(inode);
+		mutex_unlock(&(inode->i_mutex));
+		mnt_drop_write(filp->f_path.mnt);
+		return err;
+	}
 
 	default:
 		return -ENOTTY;
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -447,8 +447,7 @@ static int free_ext_block(handle_t *hand
 
 }
 
-int ext4_ext_migrate(struct inode *inode, struct file *filp,
-				unsigned int cmd, unsigned long arg)
+int ext4_ext_migrate(struct inode *inode)
 {
 	handle_t *handle;
 	int retval = 0, i;
@@ -516,12 +515,6 @@ int ext4_ext_migrate(struct inode *inode
 	 * when we add extents we extent the journal
 	 */
 	/*
-	 * inode_mutex prevent write and truncate on the file. Read still goes
-	 * through. We take i_data_sem in ext4_ext_swap_inode_data before we
-	 * switch the inode format to prevent read.
-	 */
-	mutex_lock(&(inode->i_mutex));
-	/*
 	 * Even though we take i_mutex we can still cause block allocation
 	 * via mmap write to holes. If we have allocated new blocks we fail
 	 * migrate.  New block allocation will clear EXT4_EXT_MIGRATE flag.
@@ -623,7 +616,6 @@ err_out:
 	tmp_inode->i_nlink = 0;
 
 	ext4_journal_stop(handle);
-	mutex_unlock(&(inode->i_mutex));
 
 	if (tmp_inode)
 		iput(tmp_inode);

