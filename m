From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext3 onlie resize failure due to small journal size
Date: Wed, 11 Jul 2007 11:38:21 -0600
Message-ID: <20070711173821.GA5495@schatzie.adilger.int>
References: <4694E279.1060107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	Amit K Arora <amitarora@in.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Suzuki <suzuki@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:46956 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXGLFHo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 01:07:44 -0400
Content-Disposition: inline
In-Reply-To: <4694E279.1060107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 11, 2007  19:30 +0530, Suzuki wrote:
> Trying to resize a mounted ext3 filesystem fails due to small journal size.
> 
> Background :
> 
> The filesystem was created with default values, except blocksize = 4K on 
> a LV partition. Later we tried extended the partition to +16M and tried 
> to resize the fs using resize2fs, while it was mounted.
> 
> While adding the new blockgroup, inside setup_new_group_blocks() we hit 
> the limit because we are requesting for a a credit value of 2 + 
> sbi->s_itb_per_group which in the case of the file system below is 1026 
> while the max_transaction credits possible is 1024 for the fs.
> 
> journal->j_maxlen = inode->i_size / blocksize = 16M/4K = 4K
> 
> journal->j_max_transaction_buffers = journal->j_maxlen / 4 = 1K
> 
> journal->j_max_transaction_buffers = 1024.
> 
> Is this a supported operation ? If yes, what could be the best way to 
> fix it ?
> 
> Resizing the journal is not supported at the moment :(.

You can't do a journal resize online, but you can wait until your next
outage and resize the journal at that time.  Even a few extra blocks
would be enough.  I guess this is a corner case that hasn't been hit
before.  It might make sense to have the ext2fs_figure_journal_size()
take this into account when making the filesystem?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
