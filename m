From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: Sun, 7 Oct 2012 14:10:25 -0400
Message-ID: <20121007181025.GA30198@thunk.org>
References: <507185F8.3040700@tao.ma>
 <20121007150919.17299.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tm@tao.ma, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54303 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2JGSKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Oct 2012 14:10:31 -0400
Content-Disposition: inline
In-Reply-To: <20121007150919.17299.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I just had a random thought.  Which bootloader are you using?  Is it
grub, or grub2 per chance?

I wonder if it's grub modifying the file system and touching the
superblock, and not knowing about the new metadata checksum feature....

	    	    	    	      	  - Ted
