From: David Howells <dhowells@redhat.com>
Subject: Re: Is EXT4_FITS_IN_INODE() broken?
Date: Fri, 06 Nov 2015 10:05:16 +0000
Message-ID: <24416.1446804316@warthog.procyon.org.uk>
References: <25591.1446743937@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161270AbbKFKFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2015 05:05:19 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 1EC5CA4508
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2015 10:05:19 +0000 (UTC)
In-Reply-To: <25591.1446743937@warthog.procyon.org.uk>
Content-ID: <24415.1446804316.1@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

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

Actually, it's not a problem - it's using i_extra_isize from the einode, not
the raw inode.

David
