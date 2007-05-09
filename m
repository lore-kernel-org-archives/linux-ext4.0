From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: commit only journal entries older than commit period?
Date: Wed, 9 May 2007 09:20:29 -0700
Message-ID: <20070509162029.GM6375@schatzie.adilger.int>
References: <c384c5ea0705090631v1fa61e73kc54e8173b73c25d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54219 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbXEIQoS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 12:44:18 -0400
Content-Disposition: inline
In-Reply-To: <c384c5ea0705090631v1fa61e73kc54e8173b73c25d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 09, 2007  15:31 +0200, Leon Woestenberg wrote:
> this is something I have long wondered about but have been afraid to ask.
> 
> When my system is chewing away on builds, the disk I/O write access
> pattern of my ext3 root filesystem (using CFQ, Intel SATA controller,
> hard disk) when visualized by GNOME System Monitor clearly shows a
> repetitive landscape of large peaks, 5 seconds apart, which not much
> activity inbetween.
> 
> I understand that's due to the ex3 journal commit interval (defaults
> to 5 seconds).
> 
> But why isn't the filesystem continuously committing only that part of
> the journal that is older than 5 seconds?
> 
> I would then expect the write requests to be smoothened over time,
> which can only be good in terms of performance and low latency.

The journal cannot start checkpoint of blocks to the filesystem until
the transaction is committed, otherwise a crash would leave the filesystem
inconsistent.  After the transaction is committed the blocks are written
into the fs and I'd guess that this can happen quickly enough that it
only takes a fraction of a second.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
