From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] dir_index: error out instead of BUG on corrupt hash dir limit
Date: Fri, 10 Aug 2007 02:26:22 -0600
Message-ID: <20070810082622.GK6689@schatzie.adilger.int>
References: <46BB8830.3060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:33192 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbXHJI0W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 04:26:22 -0400
Content-Disposition: inline
In-Reply-To: <46BB8830.3060009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 09, 2007  16:33 -0500, Eric Sandeen wrote:
> A corrupt ondisk hash dir limit will trip an assert in dx_probe,
> which calls BUG().  Instead, we can just issue the warning and
> fail dx_probe like the other 3 tests just before it.  Thanks
> to aviro for suggesting this...  Tested with a hand-crafted
> corrupt ext3 image, issues:
> 
> EXT3-fs warning (device loop0): dx_probe: Corrupt limit in dir inode 14337
> 
> vs. previous:
> 
> Assertion failure in dx_probe() at fs/ext3/namei.c:383: "dx_get_limit(entries) == dx_root_limit(dir, root->info.info_length)"
> ------------[ cut here ]------------
> kernel BUG at fs/ext3/namei.c:383!

This has my blessing, you can add:

Acked-by: Andreas Dilger <adilger@clusterfs.com>

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
