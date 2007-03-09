From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Fw: EXT3-fs warning (device sdd2): dx_probe: Unrecognised inode hash code 232
Date: Fri, 9 Mar 2007 14:00:37 -0700
Message-ID: <20070309210037.GY5823@schatzie.adilger.int>
References: <20070309074014.10ba0e88.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:40177 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXCIVAk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2007 16:00:40 -0500
Content-Disposition: inline
In-Reply-To: <20070309074014.10ba0e88.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 09, 2007  07:40 -0800, Andrew Morton wrote:
> EXT3-fs warning (device sdd2): dx_probe: Unrecognised inode hash code 232
> Assertion failure in dx_probe() at fs/ext3/namei.c:384: "dx_get_limit(entries) 
> == dx_root_limit(dir, root->info.info_length)"

Looks like corrupted on-disk or in-memory htree metadata.  We should
probably handle this more gracefully, if indeed it is corrupted on disk.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
