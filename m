From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question about JBD2 transactions
Date: Mon, 21 Mar 2016 01:21:09 -0400
Message-ID: <20160321052109.GE3331@thunk.org>
References: <loom.20160321T031409-338@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Abraham Choi <north.choi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40064 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbcCUFVN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2016 01:21:13 -0400
Content-Disposition: inline
In-Reply-To: <loom.20160321T031409-338@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2016 at 02:23:55AM +0000, Abraham Choi wrote:
> Hi all,
> 
> Frist of all, thank you for Ext4's developer.
> 
> I have encounterd a crash problem of ext4 file system on Kernel 3.18.20 
> with mounting 
> rw,seclabel,nosuid,nodev,relatime,discard,noauto_da_alloc,data=ordered 0 0.
> [   22.361511] EXT4-fs error (device sda8): ext4_mb_generate_buddy:757: 
> group 0, block bitmap and bg descriptor inconsistent: 21208 vs 21219 free 
> clusters
> I think, the reason is that recovered transactions has not recovered over 
> 39809 during booting.
> Booting N-2
> 	[   16.416979] (jbd2_journal_recover, 279): JBD2: recovery, exit 
> status 0, recovered transactions 39665 to 39728
> 	Last commit_sequence=39796
> Booting N-1
> 	[   16.626582] (jbd2_journal_recover, 279): JBD2: recovery, exit 
> status 0, recovered transactions 39730 to 39797
> 	Last commit_sequence=39866
> Booting N
> 	[   14.118542] (jbd2_journal_recover, 279): JBD2: recovery, exit 
> status 0, recovered transactions 39799 to 39809
> 	
> The root casue will be explained the more detail in the follwing.
> Jounral Blocks
> ... <Descriptor block #39808> <Data blocks> <Commit block #39808> 
> <All zero block> <Descriptor block #39809> <Data blocks> <Commit block 
> #39809> ... 
> I'm wondering that journal has all zero data, only 1 block.
> How it can be possible?
> Any tips or help would be appreciated.

Can you reproduce this?  And how did you dump out the journal blocks?
There shouldn't be an all zero block after the commit block, unless
that really was the last transaction.

				- Ted
