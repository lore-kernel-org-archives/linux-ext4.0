From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Tue, 9 Sep 2008 09:09:00 -0400
Message-ID: <20080909130900.GS8161@mit.edu>
References: <20080907121557.GA3432@x200.localdomain> <20080907160414.GB26248@charite.de> <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907162447.GB32429@mit.edu> <20080907164130.GA3376@x200.localdomain> <20080908143951.GH8161@mit.edu> <20080909070630.GC5786@x200.localdomain> <20080909001203.7480549e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64677 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbYIINJQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 09:09:16 -0400
Content-Disposition: inline
In-Reply-To: <20080909001203.7480549e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 12:12:03AM -0700, Andrew Morton wrote:
> On Tue, 9 Sep 2008 11:06:30 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Mon, Sep 08, 2008 at 10:39:51AM -0400, Theodore Tso wrote:
> > > Here's what I've checked into the ext4 patch queue for submission to
> > > mainline at the next merge window.  I've added a bit more error
> > > checking in case proc_mkdir() fails and returns NULL.
> > 
> > Hopefully, Andrew, will pick up original non-broken patch.
> 
> What does this mean??

Alexey's trying to bypass the ext4 maintainers.  :-)

Alexey, both of the problems which you pointed out I noticed last
night and have already been fixed and commited to the ext4 patch
queue.  Please see attached.  This patch *is* better than your
original one since using strdup is better than open coding it in C.

Andrew, note that some of the patches in the upcoming ext4 patch set
which I am preparing for -mm and linux-next submission depend on a the
percpu cleanup patch which is in already in -mm.  I've left it in the
ext4 series file since the patchset won't apply against mainline
without it, but I've left comments in the series file that should make
this clear.

I'm not sure how you are managing -mm these days, but it looks like
you are using git more, and so if you are pulling in changes in via
linux-next, git will do the right thing and drop the duplicated patch.
There is a similar issue with the FIEMAP patches and some ext3
patches, but the FIEMAP patches will get dropped since Eric has
promised to get on Mark Fasheh's case to submit for merging or to
submit them yourself, and the ext3 patches I will submit to you
separately.

Regards,

						- Ted

ext4: fix #11321: create /proc/ext4/*/stats more carefully

From: Alexey Dobriyan <adobriyan@gmail.com>

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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2721643..78d628b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2785,14 +2785,20 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct proc_dir_entry *proc;
-	char devname[64];
+	char devname[64], *p;
 
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
@@ -2804,7 +2810,6 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
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
