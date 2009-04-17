From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
	blocks...
Date: Fri, 17 Apr 2009 07:56:59 -0400
Message-ID: <20090417115659.GB7117@mit.edu>
References: <gs9nm5$8m1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49699 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363AbZDQL5I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 07:57:08 -0400
Content-Disposition: inline
In-Reply-To: <gs9nm5$8m1$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 17, 2009 at 12:03:33PM +0100, Jeremy Sanders wrote:
> Hi - I'm trying out ext4 on a large 8.2 TB software raid device (md). On 
> rebooting (cleanly unmounting), I tried an fsck on the device. I get the 
> following:
> 
> [root@xback2 ~]# fsck /dev/md0
> fsck 1.41.4 (27-Jan-2009)
> e2fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Group descriptor 0 checksum is invalid.  Fix<y>?
> 
> It then finds lots of bad group descriptors.

What happened afterwards?   Did fsck complete successfully?

I see from the dumpe2fs that you sent it had only been in use for a
week.  How were you using the filesystem?  Did you try using the
online resize feature at any time?

The problem is that any number of things could have caused the block
group descriptors to be corrupted.

						- Ted
