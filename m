From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 26 Aug 2010 01:04:42 +0200
Message-ID: <20100825230442.GH2738@quack.suse.cz>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
 <20100824131735.GD3713@quack.suse.cz>
 <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="s2ZSL+KKDSLx8OML"
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab0HYXF3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Aug 2010 19:05:29 -0400
Content-Disposition: inline
In-Reply-To: <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 25-08-10 09:05:52, Masayoshi MIZUMA wrote:
> On Tue, 24 Aug 2010 15:17:36 +0200
> Jan Kara <jack@suse.cz> wrote:
> > On Mon 23-08-10 09:50:56, Masayoshi MIZUMA wrote:
> > > In ext3 filesystem, if following conditions 1., 2., 3. and 4. is satisfied,
> > > getfattr can't search the extended attribute (EA) after remount.
> > > 
> > > Condition:
> > >     1. the inode size is over 128 byte
> > >     2. "lost+found" whose inode number is 11 was removed
> > >     3. the 11th inode is used for a file.
> > >     4. the EA locates in-inode
> > > 
> > > This happens because of following logic:
> > >     i_extra_isize is set to over 0 by ext3_new_inode() when we create
> > >     a file whose inode number is 11 after removing "lost+found".
> > >     Therefore setfattr creates the EA in-inode.
> > >     After remount, i_extra_isize of 11th inode is set to 0 by ext3_iget()
> > >     when we lookup the file, so getfattr tries to search the EA out-inode.
> > >     However, the EA locates in-inode, so getfattr can't search the EA.
> > > 
> > > How to reproduce:
> > >     1. mkfs.ext3 -I 256 /dev/sdXX
> > >     2. mount -o acl,user_xattr  /dev/sdXX /TEST
> > >     3. rm -rf /TEST/*
> > >     4. touch /TEST/file (whose inode number is 11)
> > >     5. cd /TEST; setfattr -n user.foo0 -v bar0 file
> > >     6. cd /TEST; getfattr -d file
> > >        -> can see foo0/bar0
> > >     7. umount  /dev/sdXX
> > >     8. mount -o acl,user_xattr /dev/sdXX /TEST
> > >     9. cd /TEST; getfattr -d file
> > >        -> can't see foo0/bar0
> > > 
> > > Though the 11th inode is used for "lost+found" normally, the other
> > > file can also use it. Therefore, i_extra_isize of 11th inode should be set
> > > to the suitable value by ext3_iget().
> >   Hmm, with which kernel have you tested that? Because my 2.6.32 kernel
> > works just fine (and looking into the code, all should be handled well).
> I tested at 2.6.35.
> 
> > Look:
> > mount -o loop,user_xattr ~jack/fs-images/ext3-image /mnt/
> > quack:/crypted/home/jack # cd /mnt/
> > quack:/mnt # touch file
> > quack:/mnt # ls -i file
> > 11 file
> > quack:/mnt # setfattr -n user.foo0 -v bar0 file
> > quack:/mnt # getfattr -d file
> > # file: file
> > user.foo0="bar0"
> > 
> > quack:/mnt # cd
> > quack:~ # umount /mnt
> > quack:~ # mount -o loop,user_xattr ~jack/fs-images/ext3-image /mnt/
> > quack:~ # getfattr -d /mnt/file
> > getfattr: Removing leading '/' from absolute path names
> > # file: mnt/file
> > user.foo0="bar0"
> What size is the inode ? This problem happens if the size is larger than 128 byte.
> (I tested at 256 byte inode.)
  Ah, that was the reason. Thanks. But looking at the implications, I'm a bit
reluctant to do the change you propose. If someone has a filesystem created
by old mkfs, he could suddently see corrupted xattrs in his lost+found
directory with the new kernel. Not that there would be a big chance this
happens but people run various strange environments...
  So I'd rather choose a safer approach for ext3 - see attached patch - it
fixes the problem for me.  For ext4 your patch is definitely a way to go,
so please port it to ext4 and send it to Ted Tso. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--s2ZSL+KKDSLx8OML
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


--s2ZSL+KKDSLx8OML--
