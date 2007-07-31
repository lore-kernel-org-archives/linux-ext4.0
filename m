From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: 64 bit support for ext4 problem
Date: Tue, 31 Jul 2007 09:35:16 -0500
Message-ID: <20070731143516.GH5469@schatzie.adilger.int>
References: <46AEE61B.5000207@fmi.uni-sofia.bg> <46AF033D.6020909@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: anton.andreev@fmi.uni-sofia.bg, linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:54995 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759775AbXGaOfT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2007 10:35:19 -0400
Content-Disposition: inline
In-Reply-To: <46AF033D.6020909@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 31, 2007  11:39 +0200, Valerie Clement wrote:
> Ext4 supports 48-bit physical block numbers, not yet 64-bit physical 
> block numbers; this is due to the use of extents mapping.
> 
> If you want to use the extent format (mount -t ext4dev -o extents), I 
> think you should use the latest version of e2fsprogs available here:
> http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.40.2.tar.gz
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-1.40.2.tar.gz
> This version should integrate the extents capability.

Actually, I don't think the official e2fsprogs-1.40 supports extents yet?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
