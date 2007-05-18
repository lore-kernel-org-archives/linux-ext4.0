From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Online defragmentation and ext4migrate
Date: Fri, 18 May 2007 15:05:06 -0600
Message-ID: <20070518210506.GE5286@schatzie.adilger.int>
References: <464DA4ED.9040408@linux.vnet.ibm.com> <1179519594.6109.40.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52969 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbXERVFI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 17:05:08 -0400
Content-Disposition: inline
In-Reply-To: <1179519594.6109.40.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 18, 2007  13:19 -0700, Eric wrote:
> A defragmentation routine makes files contiguous on disk. A better
> defragmentation routine intelligently locates data structures on the
> disk so that files and directories are placed to minimize latency and
> maximize throughput now, AND so that this will continue to happen in the
> future. Typically this means not only making files contiguous, but also
> consolidating free space at the end of the volume so that the block

It is not necessarily best to put free space at the END of the volume
(that is very FAT-centric) but it does make sense to consolidate free
space within each block group.

> But on an extent file there is a logical, high-performance mapping
> between the on-disk structures that keep track of which blocks belong to
> which files and the data returned by the as-yet-to-be-implemented FIEMAP
> ioctl, which could make defragging faster and more fun.
> 
> http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg01434.html

Yeah, I wish I had time to finish working on this.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
