From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Fsck of read-only FS w/ external journal fails after
 1.42.5?
Date: Sat, 4 May 2013 19:33:07 -0400
Message-ID: <20130504233307.GB5948@thunk.org>
References: <20130504195350.GA20046@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Calvin Owens <jcalvinowens@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46353 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3EDX5O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 19:57:14 -0400
Content-Disposition: inline
In-Reply-To: <20130504195350.GA20046@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 04, 2013 at 02:53:50PM -0500, Calvin Owens wrote:
> 
> Commit a85f8350 (http://goo.gl/aCykm) makes it impossible to fsck an
> ext4 filesystem w/ external journal if it is mounted read-only. Certain
> distros (Gentoo in my case) expect to be able to do this on the root
> filesystem at boot time, and get very upset if they can't.

The fact that e2fsck would working with root file systems with an
external journal between commits 47c1b8e166 and a85f8350 was by accident.
Can you try this patch?  This should allow external journals on the
root file system to work properly.

						- Ted

>From 26991d026e4b555229a4466ae4d003420321bbd2 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sat, 4 May 2013 19:07:18 -0400
Subject: [PATCH] e2fsck: don't use IO_FLAG_EXCLUSIVE for read-only root file
 systems

When opening the external journal, use the same logic to decide
whether or not to open the file system with EXT2_FLAG_EXCLUSIVE found
in main().

Otherwise, it's not posible to use e2fsck when the root file system is
using an external journal.

Reported-by: Calvin Owens <jcalvinowens@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 767ea10..69771da 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -372,9 +372,19 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 #ifndef USE_INODE_IO
 	if (ext_journal)
 #endif
-		retval = io_ptr->open(journal_name,
-				      IO_FLAG_RW | IO_FLAG_EXCLUSIVE,
+	{
+		int flags = IO_FLAG_RW;
+		if (!(ctx->mount_flags & EXT2_MF_ISROOT &&
+		      ctx->mount_flags & EXT2_MF_READONLY))
+			flags |= IO_FLAG_EXCLUSIVE;
+		if ((ctx->mount_flags & EXT2_MF_READONLY) &&
+		    (ctx->options & E2F_OPT_FORCE))
+			flags &= ~IO_FLAG_EXCLUSIVE;
+
+
+		retval = io_ptr->open(journal_name, flags,
 				      &ctx->journal_io);
+	}
 	if (retval)
 		goto errout;
 
-- 
1.7.12.rc0.22.gcdd159b

