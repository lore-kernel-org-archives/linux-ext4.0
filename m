From: Andreas Dilger <adilger@sun.com>
Subject: Re: More testing: 4x parallel 2G writes, sequential reads
Date: Wed, 7 Nov 2007 16:09:05 -0700
Message-ID: <20071107230905.GQ3966@webber.adilger.int>
References: <47323F73.5080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:43959 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbXKGXJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2007 18:09:08 -0500
Content-Disposition: inline
In-Reply-To: <47323F73.5080708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 07, 2007  16:42 -0600, Eric Sandeen wrote:
> I tried ext4 vs. xfs doing 4 parallel 2G IO writes in 1M units to 4
> different subdirectories of the root of the filesystem:
> 
> http://people.redhat.com/esandeen/seekwatcher/ext4_4_threads.png
> http://people.redhat.com/esandeen/seekwatcher/xfs_4_threads.png
> http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_threads.png
> 
> and then read them back sequentially:
> 
> http://people.redhat.com/esandeen/seekwatcher/ext4_4_threads_read.png
> http://people.redhat.com/esandeen/seekwatcher/xfs_4_threads_read.png
> http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_read_threads.png
> 
> At the end of the write, ext4 had on the order of 400 extents/file, xfs
> had on the order of 30 extents/file.  It's clear especially from the
> read graph that ext4 is interleaving the 4 files, in about 5M chunks on
> average.  Throughput seems comparable between ext4 & xfs nonetheless.

The question is what the "best" result is for this kind of workload?
In HPC applications the common case is that you will also have the data
files read back in parallel instead of serially.

The test shows ext4 finishing marginally faster in the write case, and
marginally slower in the read case.  What happens if you have 4 parallel
readers?

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
