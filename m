From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: + ext4-rename-logic_sb_block.patch added to -mm tree
Date: Fri, 6 Oct 2006 00:07:57 -0600
Message-ID: <20061006060757.GI22010@schatzie.adilger.int>
References: <200610060306.k96368Tu015253@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34500 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932612AbWJFGIA
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 02:08:00 -0400
To: akpm@osdl.org
Content-Disposition: inline
In-Reply-To: <200610060306.k96368Tu015253@shell0.pdx.osdl.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 05, 2006  20:06 -0700, akpm@osdl.org wrote:
> Subject: ext4: rename logic_sb_block
> From: Andrew Morton <akpm@osdl.org>
> 
> I assume this means "logical sb block".  So call it that.
> 
> I still don't understand the name though.  A block is a block.  What's
> different about this one?

The ext3 superblock is at a 1kB offset from the start of the device.
For 1kB blocksize filesystems this is at block 1, while for 2kB+ blocksize
filesystems this is block 0 + 1024 bytes...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

