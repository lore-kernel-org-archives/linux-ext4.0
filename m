From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Serious bug?
Date: Mon, 30 Jul 2012 22:42:36 -0400
Message-ID: <20120731024236.GB5027@thunk.org>
References: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42199 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2GaCmp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 22:42:45 -0400
Content-Disposition: inline
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 02:17:03AM +0000, Nelson, John R wrote:
> Hi,
>  I created a big 400GB file image and formatted it with mkfs.ext4. the format failed with
> 
> Warning: could not erase sector 2: Attempt to write block to filesystem resulted in short write
>
> i then checked my dmesg and found error on my sda3 partition
> [  119.578077] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 53, depth: 2 pblock 0

All of the errors indicate that an extent tree block in inode
#32243725 was corrupted.  When you deleted the image file, that
destroyed the evidence, so that's why fsck didn't reveal any problems.

In terms of how and why the extent tree block got corrupted, that is a
mystery.  It could have been a memory corruption, due to hardware or
software bug in the kernel.  It could be a disk corruption, again due
to hardware or software bug.

So we can note what happened, and see if we see anything else similar,
ut unless you can replicate it, I'm not sure we can do much more at
the moment.

Regardless, thank you for the report.   We'll keep an eye out....

	    	      	      		      - Ted
