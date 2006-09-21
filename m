From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] move "_hi" block numbers
Date: Thu, 21 Sep 2006 02:50:51 -0700
Message-ID: <20060921095051.GA5729@schatzie.adilger.int>
References: <20060915152252.GA1628@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:7141 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751098AbWIUJux
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Sep 2006 05:50:53 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060915152252.GA1628@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 15, 2006  17:22 +0200, Alexandre Ratchov wrote:
> the attached patch moves ``_hi'' bits of bg_inode_bitmap, bg_block_bitmap
> and bg_inode_table in the larger part of the group descriptor structure, as
> we discussed the last week. 
> 
> With this patch, we let a gap in the first 32 byte part of the group
> descriptor. It can be used to port future ext3 features to ext4 or to
> backport features from ext4 to ext3, without interfering with the 64bit
> support.

Looks good to me.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

