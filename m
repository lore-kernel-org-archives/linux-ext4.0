From: tytso@mit.edu
Subject: Re: [PATCH, RFC 3/3] ext4: Add option for squelching ext4 errors
 to prevent dmesg from filling up
Date: Fri, 19 Mar 2010 22:20:16 -0400
Message-ID: <20100320022016.GC26083@thunk.org>
References: <1268959842-4697-1-git-send-email-tytso@mit.edu>
 <1268959842-4697-3-git-send-email-tytso@mit.edu>
 <7C462C5D-0B00-45A8-95A4-AEF74EBC534E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49273 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0CTCVT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Mar 2010 22:21:19 -0400
Content-Disposition: inline
In-Reply-To: <7C462C5D-0B00-45A8-95A4-AEF74EBC534E@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 19, 2010 at 04:56:13PM -0600, Andreas Dilger wrote:
> On 2010-03-18, at 18:50, Theodore Ts'o wrote:
> >@@ -363,12 +363,19 @@ void ext4_error_inode(const char *function,
> >struct inode *inode,
> >{
> >	va_list args;
> >
> >+	if (!ext4_test_inode_state(inode, EXT4_STATE_ERR_SQUELCHED) ||
> >+	    !(EXT4_SB(inode->i_sb)->s_mount_flags & EXT4_MF_FS_SQUELCH)) {
> >+		va_start(args, fmt);
> >+		printk(KERN_CRIT "EXT4-fs error (device %s): %s: "
> >+		       "inode #%lu: (comm %s) ",
> >+		       inode->i_sb->s_id, function, inode->i_ino,
> >+		       current->comm);
> >+		vprintk(fmt, args);
> >+		printk("\n");
> >+		va_end(args);
> 
> Shouldn't this really be using ext4_msg()?

ext4_msg only prints messages of the form:

EXT4-fs (<dev>): message

ext4_error() and friends only prints messages of the form:

EXT4-fs error (<dev>): error message

And ext4_warning() and friends only prints messages of the form:

EXT4-fs warning (<dev>): error message

(at various different priority levels)

So no, at the moment, when we are printing something that is intending
to be found via syslog parsers as an ext4 file system error, we can't
use ext4_msg().

Could we do some more factorization of our various ext4 printk
functions?  Probably.  But the point of this patch wasn't to
refactorize the ext4 printk functions....

					- Ted
