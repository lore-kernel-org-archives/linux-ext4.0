From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Fix error handling on inode bitmap corruption
Date: Fri, 9 Dec 2011 00:13:18 +0100
Message-ID: <20111208231318.GD24269@quack.suse.cz>
References: <1323376115-23881-1-git-send-email-jack@suse.cz>
 <1323376115-23881-2-git-send-email-jack@suse.cz>
 <4EE12211.3000604@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="eAbsdosE1cNLO4uF"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1LHXNU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 18:13:20 -0500
Content-Disposition: inline
In-Reply-To: <4EE12211.3000604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 08-12-11 14:46:09, Eric Sandeen wrote:
> On 12/8/11 2:28 PM, Jan Kara wrote:
> > When insert_inode_locked() fails in ext3_new_inode() it most likely
> > means inode bitmap got corrupted and we allocated again inode which
> > is already in use. Also doing unlock_new_inode() during error recovery
> > is wrong since inode does not have I_NEW set. Fix the problem by jumping
> > to fail: (instead of fail_drop:) which declares filesystem error and
> > does not call unlock_new_inode().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> I think ext2 could use the same treatment.
  Good point. Attached is a similar patch for ext2 (I didn't use your patch
so that all ext? are consistent and declare filesystem error when
insert_inode_locked() fails). Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--eAbsdosE1cNLO4uF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-error-handling-on-inode-bitmap-corruption.patch"

>From 9d1602d9a8b895d0b6dbb30a6d2a148558912dad Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 9 Dec 2011 00:08:58 +0100
Subject: [PATCH] ext2: Fix error handling on inode bitmap corruption

When insert_inode_locked() fails in ext2_new_inode() it most likely means inode
bitmap got corrupted and we allocated again inode which is already in use. Also
doing unlock_new_inode() during error recovery is wrong since the inode does
not have I_NEW set. Fix the problem by informing about filesystem error and
jumping to fail: (instead of fail_drop:) which doesn't call unlock_new_inode().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ialloc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index c4e81df..78502c1 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -573,8 +573,11 @@ got:
 	inode->i_generation = sbi->s_next_generation++;
 	spin_unlock(&sbi->s_next_gen_lock);
 	if (insert_inode_locked(inode) < 0) {
-		err = -EINVAL;
-		goto fail_drop;
+		ext2_error(sb, "ext2_new_inode",
+			   "inode number already in use - inode=%lu",
+			   (unsigned long) ino);
+		err = -EIO;
+		goto fail;
 	}
 
 	dquot_initialize(inode);
-- 
1.7.1


--eAbsdosE1cNLO4uF--
