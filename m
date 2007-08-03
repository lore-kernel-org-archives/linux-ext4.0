From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: How to insure ext4_alloc_blocks always returns blocks below 0xffffffff when using indirect index.
Date: Fri, 3 Aug 2007 12:09:16 -0600
Message-ID: <20070803180916.GT6142@schatzie.adilger.int>
References: <3d0408630708021922h7f382cdfk1d67f5f25029c2d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40051 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044AbXHCSJR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 14:09:17 -0400
Content-Disposition: inline
In-Reply-To: <3d0408630708021922h7f382cdfk1d67f5f25029c2d1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 03, 2007  10:22 +0800, Yan Zheng wrote:
> Druing reading the source codes of indirect index,  there is a doubt
> in my mind. When using indirect index, physical block number must not
> exceed 0xffffffff, but I cann' t find any clue  about how
> ext4_alloc_blocks insure that.  Codes that check 64bit_feature is only
> in ext4_fill_super and they do nothing affects block allocation
> algorithm.  Maybe ext4_alloc_blocks should  check whether inode has
> EXT4_EXTENTS_FL flags and only search block groups that have blocks
> below 0xffffffff when not.
> 
> The source codes I read is 2.6.22.

Good question.  It is intended that extents be used for filesystems
larger than 2^32 blocks, but there is no guarantee that existing
block-mapped files will not still exist.

I think the check you propose makes sense.  The code should return
EFBIG or maybe EOVERFLOW in this case (not ENOSPC I think).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
