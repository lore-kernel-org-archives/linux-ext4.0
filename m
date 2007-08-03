From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: What is fragment in ext3/4 ?
Date: Thu, 2 Aug 2007 18:02:28 -0600
Message-ID: <20070803000228.GO6142@schatzie.adilger.int>
References: <46B1A9F9.3050901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Coly Li <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:43669 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbXHCAC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 20:02:29 -0400
Content-Disposition: inline
In-Reply-To: <46B1A9F9.3050901@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 02, 2007  17:55 +0800, Coly Li wrote:
> These days, when I read the source code of mke2fs, I found an option -f
> to set the fragment size.
> 
> But I can not find any explaining for ext3/4 framgment from google,
> excepting someone saying ext2/3 does not support this feature.
> 
> Can anyone tell me what is the function or purpose of fragment of ext
> file system ?

This is an obsolete concept from BSD that was never used by ext[234].
Consider a "fragment" in this context to be the same as a "tail" for
reiserfs.  A very small file, or the end of a file that is less than
a block.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
