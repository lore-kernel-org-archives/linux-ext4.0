From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not try to write superblock on journal-less
 readonly remount
Date: Tue, 25 Dec 2012 14:09:47 -0500
Message-ID: <20121225190947.GA16669@thunk.org>
References: <1351154397-14743-1-git-send-email-mjt@msgid.tls.msk.ru>
 <50D025FE.5040201@msgid.tls.msk.ru>
 <50D089A2.8030809@redhat.com>
 <50D2D959.9060300@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40306 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2LYTJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Dec 2012 14:09:54 -0500
Content-Disposition: inline
In-Reply-To: <50D2D959.9060300@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, I'll take this; I'm going to take your suggestion and only call
ext4_commit_super() when we are going from a read-write to read-only
mount, since that's the only time when we need to force that the
superblock be written out.

					- Ted

commit 86fffe43a74af16e306896eba8210bebd33bfd1f
Author: Michael Tokarev <mjt@tls.msk.ru>
Date:   Tue Dec 25 14:08:16 2012 -0500

    ext4: do not try to write superblock on ro remount w/o journal
    
    When a journal-less ext4 filesystem is mounted on a read-only block
    device (blockdev --setro will do), each remount (for other, unrelated,
    flags, like suid=>nosuid etc) results in a series of scary messages
    from kernel telling about I/O errors on the device.
    
    This is becauese of the following code ext4_remount():
    
           if (sbi->s_journal == NULL)
                    ext4_commit_super(sb, 1);
    
    at the end of remount procedure, which forces writing (flushing) of
    a superblock regardless whenever it is dirty or not, if the filesystem
    is readonly or not, and whenever the device itself is readonly or not.
    
    We only need call ext4_commit_super when the file system had been
    previously mounted read/write.
    
    Thanks to Eric Sandeen for help in diagnosing this issue.
    
    Cc: stable@vger.kernel.org
    Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4969167..183ae34 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4729,7 +4729,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	ext4_setup_system_zone(sb);
-	if (sbi->s_journal == NULL)
+	if (sbi->s_journal == NULL && !(old_sb_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
 #ifdef CONFIG_QUOTA
