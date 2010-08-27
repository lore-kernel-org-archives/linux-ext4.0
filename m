From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Fri, 27 Aug 2010 15:58:38 +0200
Message-ID: <20100827135838.GC3274@quack.suse.cz>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
 <20100824131735.GD3713@quack.suse.cz>
 <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
 <20100825230442.GH2738@quack.suse.cz>
 <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
 <20100826122754.GI3294@quack.suse.cz>
 <771B1868-889A-4DD1-A247-9E183395E627@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0H0N70 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Aug 2010 09:59:26 -0400
Content-Disposition: inline
In-Reply-To: <771B1868-889A-4DD1-A247-9E183395E627@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi Andreas,

  first let me explain one thing: I definitely agree that the issue
spotted by Masayoshi MIZUMA is more serious than some possible problem
with ancient e2fsprogs. What I was discussing about is, whether we should
fix the issue with the original patch (removing the workaround from
ext3_iget) or with my patch (putting the same logic into ext3_new_inode so
that it does not create xattrs which ext3_iget will just ignore).
  The disadvantage of my fix is that xattrs for inos <= EXT3_FIRST_INO will
be always stored out of inode, the disadvantage of the original patch is
the remote possibility of problems with ancient e2fsprogs.
  So do you disagree with my way of fixing things or is that fine with you
and we just misunderstood?
  BTW, I've attached my fix for reference again.

On Thu 26-08-10 17:59:31, Andreas Dilger wrote:
> On 2010-08-26, at 06:27, Jan Kara wrote:
> > On Wed 25-08-10 17:39:11, Andreas Dilger wrote:
> >> The fix to e2fsck for this issue has been around for a long time, AFAIK.
> >> It was only needed in the kernel while the broken mke2fs was in wide use,
> >> and before a fixed e2fsck was available.
> > 
> > I agree but rather old e2fsprogs are still in use and if a filesystem
> > created by these e2fsprogs would be (possibly on a different machine)
> > accessed by the new kernel it would see corrupted xattrs.
> 
> The kernel should detect if there is the xattr magic before accessing
> this space.  I think the only fallout of an uninitialized i_extra_isize
> is that it might waste some space in the inode, or more likely it will
> detect that i_extra_isize is invalid.
> 
> In that case, ext3 could be more friendly for (i_ino ==
> EXT3_FIRST_INO(inode->i_sb)) it makes sense to just set i_extra_isize = 0
> instead of returning -EIO and marking it a bad inode:
> 
>        if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
>                 ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
>                 if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
>                     EXT3_INODE_SIZE(inode->i_sb)) {
>                         /*
>                          * Old mke2fs <= 1.37 didn't zero i_extra_isize for large
>                          * reserved inodes.  Instead of assuming corruption and
>                          * returning an error, just reset i_extra_isize for them.
>                          * Remove this in 2013 (RHEL3 EOL).
>                          */
>                         if (inode->i_ino <= EXT3_FIRST_INO(inode->i_sb)) {
>                                 ei->i_extra_isize = 0;
>                         } else {
>                                 brelse (bh);
>                                 ret = -EIO;
>                                 goto bad_inode;
>                         }
>                 }
  Ah, right I didn't know about the XATTR magic. So with the above
workaround I'd feel safe also with the original solution.

> > I've looked at our
> > supported products (the oldest is currently SLES9 SP3) and it has e2fsprogs
> > 1.38. This should be new enough. But RHEL3 which is also still supported
> > for another three years has e2fsprogs 1.32 so these are buggy. So I'd
> > rather be on the safe side and fix the bug by consistently refusing to
> > store extented attributes in inode for inodes <= EXT3_FIRST_INO + 1 as I
> > don't think that really costs us much...
> 
> The question is what problem are you trying to prevent?  Do people run an
> ancient RHEL3 userspace with a spanking-new 2.6.37 kernel?  Won't there
> be all sorts of other problems there, because RHEL3 was released with a
> 2.4.x kernel that would prevent this from happening?  It may even be that
> Eric back-ported this fix to RHEL4 at the time...
> 
> Generally, either people leave their software alone, because they need
> stability, or the people who upgrade a lot will tend to also upgrade
> everything at the same time.  The only realistic scenario is hardware
> failure that forces a new kernel install to support the new hardware, but
> applications that depend on the old distro.
> 
> The question is whether RHEL3 has a realistic chance to work with such a
> new kernel?  Secondly, they would have had to format their filesystem
> with 256-byte inodes, which was almost unheard of at that time.  Finally,
> they would have to delete lost+found and re-use that inode.  I don't
> think the chances of this happening are very high.
  I agree that a combination of new kernel + ancient e2fsprogs is highly
unlikely for a single machine. But a situation where you format your
portable USB drive on an ancient server and then attach it to your laptop
isn't so remote, although the chance that you specify inode size 256 puts
it in the realm of almost-fiction as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--MGYHOYXEY6WxJCY8
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Fix-lost-extented-attributes-for-inode-with-ino.patch"

>From d5178155096ce3c53ae43a463fe1b2089645e7ee Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Aug 2010 00:54:39 +0200
Subject: [PATCH] ext3: Fix lost extented attributes for inode with ino == 11

If a filesystem has inode size > 128 and someone deletes lost+found and
reuses inode 11 for some other file, extented attributes set for this
inode before umount will get lost after remounting the filesystem. This
is because extended attributes will get stored in an inode but ext3_iget
will ignore them due to workaround of a bug in an old mkfs.

Fix the problem by initializing i_extra_isize to 0 for freshly allocated
inodes where mkfs workaround in ext3_iget applies. This way these inodes
will always store extended attributes in a special block and no problems
occur.

The bug was spotted and a reproduction test provided by:
  Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ialloc.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4ab72db..9724aef 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -570,9 +570,14 @@ got:
 	ei->i_state_flags = 0;
 	ext3_set_inode_state(inode, EXT3_STATE_NEW);
 
-	ei->i_extra_isize =
-		(EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) ?
-		sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE : 0;
+	/* See comment in ext3_iget for explanation */
+	if (ino >= EXT3_FIRST_INO(sb) + 1 &&
+	    EXT3_INODE_SIZE(sb) > EXT3_GOOD_OLD_INODE_SIZE) {
+		ei->i_extra_isize =
+			sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE;
+	} else {
+		ei->i_extra_isize = 0;
+	}
 
 	ret = inode;
 	dquot_initialize(inode);
-- 
1.6.4.2


--MGYHOYXEY6WxJCY8--
