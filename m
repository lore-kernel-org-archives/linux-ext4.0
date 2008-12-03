From: Greg KH <gregkh@suse.de>
Subject: [patch 080/104] ext4: fix #11321: create /proc/ext4/*/stats more
	carefully
Date: Wed, 3 Dec 2008 11:56:06 -0800
Message-ID: <20081203195606.GC8950@kroah.com>
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
	Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753236AbYLCT5l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:41 -0500
Content-Disposition: inline; filename="ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexey Dobriyan <adobriyan@gmail.com>

(cherry picked from commit 899fc1a4cf404747de2666534d508804597ee22f)

ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
basis is taken from bdevname, which, surprise, can contain slash.

However, proc while allowing to use proc_create("a/b", parent) form of
PDE creation, assumes that parent/a was already created.

bdevname in question is 'cciss/c0d0p9', directory is not created and all
this stuff goes directly into /proc (which is real bug).

Warning comes when _second_ partition is mounted.

http://bugzilla.kernel.org/show_bug.cgi?id=11321

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2785,14 +2785,20 @@ static int ext4_mb_init_per_dev_proc(str
 	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct proc_dir_entry *proc;
-	char devname[64];
+	char devname[BDEVNAME_SIZE], *p;
 
 	if (proc_root_ext4 == NULL) {
 		sbi->s_mb_proc = NULL;
 		return -EINVAL;
 	}
 	bdevname(sb->s_bdev, devname);
+	p = devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
+
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
+	if (!sbi->s_mb_proc)
+		goto err_create_dir;
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
 	MB_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, max_to_scan);
@@ -2804,7 +2810,6 @@ static int ext4_mb_init_per_dev_proc(str
 	return 0;
 
 err_out:
-	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
@@ -2813,6 +2818,8 @@ err_out:
 	remove_proc_entry(EXT4_MB_STATS_NAME, sbi->s_mb_proc);
 	remove_proc_entry(devname, proc_root_ext4);
 	sbi->s_mb_proc = NULL;
+err_create_dir:
+	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 
 	return -ENOMEM;
 }
@@ -2820,12 +2827,15 @@ err_out:
 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	char devname[64];
+	char devname[BDEVNAME_SIZE], *p;
 
 	if (sbi->s_mb_proc == NULL)
 		return -EINVAL;
 
 	bdevname(sb->s_bdev, devname);
+	p = devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);

