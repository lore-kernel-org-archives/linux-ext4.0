From: David Howells <dhowells@redhat.com>
Subject: Is EXT4_FITS_IN_INODE() broken?
Date: Thu, 05 Nov 2015 17:18:57 +0000
Message-ID: <25591.1446743937@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbbKERTA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2015 12:19:00 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 6F6638E4E2
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 17:19:00 +0000 (UTC)
Content-ID: <25590.1446743937.1@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is EXT4_FITS_IN_INODE() broken?  It makes use of i_extra_isize - which is an
optional field and doesn't exist if the filesystem was made with "-I 128".

	(gdb) p &((struct ext4_inode *)0)->i_extra_isize
	$2 = (__le16 *) 0x80 <irq_stack_union+128>

Should EXT4_FITS_IN_INODE():

	#define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
		((offsetof(typeof(*ext4_inode), field) +	\
		  sizeof((ext4_inode)->field))			\
		<= (EXT4_GOOD_OLD_INODE_SIZE +			\
		    (einode)->i_extra_isize))			\

be using EXT4_INODE_SIZE() and consulting the superblock instead?

David
