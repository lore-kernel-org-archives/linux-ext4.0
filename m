From: Jan Kara <jack@suse.cz>
Subject: Re: Problem mounting ext2 using ext3?
Date: Tue, 6 May 2008 12:02:16 +0200
Message-ID: <20080506100216.GB1409@duck.suse.cz>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@v
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37235 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401AbYEFKCS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2008 06:02:18 -0400
Content-Disposition: inline
In-Reply-To: <20080505222623.GA8357@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 05-05-08 18:26:23, Theodore Tso wrote:
> On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
> > when mounting the root file system, which is ext2 (has_journal is not set).
> > Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
> > 
> > At first I thought it was an issue with the byteswapped IDE bus on Atari (a
> > new and different solution to handle this just went into mainline), but if I
> > disable CONFIG_EXT3 support, it boots up fine.
> > 
> > Is this a known problem?
> 
> I can confirm this as a regression.  You don't even need to mount it
> as a root filesystem, or do this on an 68k system.  On my x86 system,
> using a kernel based off of git commit: afa26be8 (6 commits after
> 2.6.26-rc1), mounting an ext3 filesystem, you can cause an oops by
> taking an ext2 filesystem and forcing a mount as ext3, "mount -t ext3
> /dev/closure/textext2fs /mnt").  (see below for my oops).  This does
> not occur with a kernel based off of 2.6.25, so it's a definite
> regression.
> 
> Looks like the problem is some of the recent quota cleanups.  The
> problem is that ext3_fill_super is returning an error, because the
> journal is missing.  get_sb_dev() calls ext3_fill_super, and upon
> receiving an error, it is calling deactivate_super(), which calls:
> 
> 	     DQUOT_OFF(s, 0);
> 
> (line 182 in fs/super.c, in deactivate_super(), recently modified just
> after 2.6.25, at comment 0ff5af8340aa6be44220d7237ef4a654314cf795,
> although I'm not sure this is actually the problem commit)).  
> 
> The blow up is happening because the because superblock was not fully
> set up, and the comment in the commit involved mentioned cleaning up
> what is supposed to happen when remounting a filesystem turning quota
> on or off.  I'm guessing that the changes didn't take into account
> that DQUOT_OFF() can get called with a partially set-up superblock,
> which will happen when the filesystme specific get_sb() code refuses a
> mount and returns an error.
> 
> Jan, can you take a look at this and confirm whether or not this is
> the root cause of the crash?
  Thanks Ted for looking into this. Yes, the problem is caused by my
modifications to quota code... The patch below fixes it for me and I've
also added a comment so that someone does not remove the check again in
future ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From af9d1ac1db9acea1516350d4269796061e0f2ab5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 6 May 2008 11:33:00 +0200
Subject: [PATCH] quota: Don't call sync_fs() from vfs_quota_off() when there's no quota turn off

Sometimes, vfs_quota_off() is called on a partially set up super block (for example
when fill_super() fails for some reason). In such cases we cannot call ->sync_fs()
because it can Oops because of not properly filled in super block. So in case we
find there's not quota to turn off, we just skip everything and return which fixes
the above problem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index dfba162..bdcb15e 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1491,6 +1491,16 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 
 	/* We need to serialize quota_off() for device */
 	mutex_lock(&dqopt->dqonoff_mutex);
+
+	/*
+	 * Skip everything if there's nothing to do. We have to do this becase
+	 * sometimes we are called when fill_super() failed and calling
+	 * sync_fs() in such cases does no good.
+	 */
+	if (!sb_any_quota_enabled(sb) && !sb_any_quota_suspended(sb)) {
+		mutex_unlock(&dqopt->dqonoff_mutex);
+		return 0;
+	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		toputinode[cnt] = NULL;
 		if (type != -1 && cnt != type)
-- 
1.5.2.4

