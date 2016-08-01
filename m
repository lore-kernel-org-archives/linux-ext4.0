From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xattr index for hurd
Date: Sun, 31 Jul 2016 23:42:28 -0400
Message-ID: <20160801034228.GE12853@thunk.org>
References: <a3ef36c5-cd3b-5fc2-e9fc-eb7e823f0510@outlook.com>
 <BLU175-W270CF93954CBCB94CA36CC9360@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: LastAvengers <lastavengers@outlook.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33148 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbcHADnW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Jul 2016 23:43:22 -0400
Content-Disposition: inline
In-Reply-To: <BLU175-W270CF93954CBCB94CA36CC9360@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2016 at 08:36:51AM +0000, LastAvengers wrote:
>     To Jan, Theodore and Andreas:
> 
>       Hello, I get your emails from Linux's maintainer list, I am a
>       GSoC student of the Hurd project[1].
> 
>     My project is implement xattr support for hurd's ext2 filesystem.
>       For storing hurd-specific data using 
> 
>     xattr, we want to use a new xattr namespace "gnu.". Can you
>       reserve the index 10 for us to use in hurd?
> 
>     (As index 1-9 has already used in ext4's xattr).

I will merge the following patch (see below).

Two comments: it's not just the translator field; you'll want to also
move the author field out of the core inode field as well.  Secondly,
I would suggest you use the textual representation of the namespace to
be "hurd."

To the extent that one accepts the argument that an operating system
that uses KDE for its desktop, X11 for its windowing system, Linux for
its kernel, and GNU for its userspace utilities "GNU/Linux" (and not
everyone does), it's clear that an xattr namespace that will be used
only by the Hurd kernel should be called "hurd".  After all, a
"GNU/Linux" system wouldn't need to use this new xattr namespace that
you are proposing to implement.

Best wishes,

						- Ted

commit 3b5e45dd0af7c94affb8d93950def32d6820e5ed
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jul 31 23:38:36 2016 -0400

    ext4: reserve xattr index for the Hurd
    
    The Hurd is using inode fields which restricts it from using more
    advanced ext4 file system features, due to design choices made over a
    decade ago.  By giving the Hurd an extended attribute index field we
    allow it to move the translator and author fields out of the core
    inode fields, and hopefully we can get rid of ugly hacks such as
    EXT4_OS_HURD and EXT4_MOUNT2_HURD_COMPAT somday.
    
    For more information please see:
          https://summerofcode.withgoogle.com/projects/#5869799859027968
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 69dd3e6..a92e783 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -24,6 +24,7 @@
 #define EXT4_XATTR_INDEX_SYSTEM			7
 #define EXT4_XATTR_INDEX_RICHACL		8
 #define EXT4_XATTR_INDEX_ENCRYPTION		9
+#define EXT4_XATTR_INDEX_HURD			10 /* Reserved for Hurd */
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
