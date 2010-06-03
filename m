From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Use bitops to read/modify i_flags part2
Date: Thu, 03 Jun 2010 12:48:44 +0400
Message-ID: <87iq601oyb.fsf@openvz.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
	<1274734174-28830-1-git-send-email-tytso@mit.edu>
	<87ocfwsb3m.fsf_-_@openvz.org> <20100603025559.GG24062@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45447 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab0FCIst (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 04:48:49 -0400
Received: by bwz11 with SMTP id 11so586337bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jun 2010 01:48:48 -0700 (PDT)
In-Reply-To: <20100603025559.GG24062@thunk.org> (tytso@mit.edu's message of
	"Wed, 2 Jun 2010 22:55:59 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

tytso@mit.edu writes:

> On Mon, May 31, 2010 at 12:56:45PM +0400, Dmitry Monakhov wrote:
>> "Theodore Ts'o" <tytso@mit.edu> writes:
>> 
>> > From: "Theodore Ts'o" <tytso@mit.edu>
>> >
>> > From: Dmitry Monakhov <dmonakhov@openvz.org>
>> Bad news. Bug still exist because you've missed several important chunks 
>> (ext4_set_inode_flags, ext4_inode_blocks) while porting original patch.
>> And I've missed this too on review cycle.
>> Please add following patch to patch-queue.
>
> Added to the ext4 patch queue (with minor updates to the commit
> description).
BTW. The patch that i've sent would not compile because of misstype.
So it may looks like that i've sent untested random peace of crap
from a first glance. But the truth is that that misstype was fixed
in to topmost quilt's patch so i've missed it original patch.
And indeed the bug with non-atomic bit's manipulation has gone, at
least i can't reproduce it any more. Incremental fix attached.


--=-=-=
Content-Disposition: inline; filename=ext4-Use-bitops-fix

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7b42cf8..39d1c14 100644
--- b/fs/ext4/inode.c
+++ a/fs/ext4/inode.c
@@ -4943,7 +4943,7 @@
 void ext4_get_inode_flags(struct ext4_inode_info *ei)
 {
 	unsigned int vfs_fl;
-	unsigned long old_flags, new_flags;
+	unsigned long old_fl, new_fl;
 
 	do {
 		vfs_fl = ei->vfs_inode.i_flags;

--=-=-=--
