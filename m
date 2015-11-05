From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Is EXT4_FITS_IN_INODE() broken?
Date: Thu, 5 Nov 2015 09:59:41 -0800
Message-ID: <20151105175941.GC2213@birch.djwong.org>
References: <25591.1446743937@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162245AbbKER7p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2015 12:59:45 -0500
Content-Disposition: inline
In-Reply-To: <25591.1446743937@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 05, 2015 at 05:18:57PM +0000, David Howells wrote:
> Is EXT4_FITS_IN_INODE() broken?  It makes use of i_extra_isize - which is an
> optional field and doesn't exist if the filesystem was made with "-I 128".
> 
> 	(gdb) p &((struct ext4_inode *)0)->i_extra_isize
> 	$2 = (__le16 *) 0x80 <irq_stack_union+128>
> 
> Should EXT4_FITS_IN_INODE():
> 
> 	#define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
> 		((offsetof(typeof(*ext4_inode), field) +	\
> 		  sizeof((ext4_inode)->field))			\
> 		<= (EXT4_GOOD_OLD_INODE_SIZE +			\
> 		    (einode)->i_extra_isize))			\
> 
> be using EXT4_INODE_SIZE() and consulting the superblock instead?

In theory, all the callers should check EXT4_INODE_SIZE() beforehand...

...but that doesn't seem to be happening for the *INODE_[SG]ET_XTIME macros.
I think it's time to turn all those macros into proper static inline functions
and make them do the size checks rather than hoping we open-code it correctly.

(Also, the XTIME macros themselves are ugly.)

--D

> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
