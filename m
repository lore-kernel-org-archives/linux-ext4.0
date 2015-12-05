From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tune2fs: confirm slow/dangerous operations
Date: Fri, 4 Dec 2015 17:21:18 -0800
Message-ID: <20151205012118.GM10580@birch.djwong.org>
References: <20151203204024.GI10580@birch.djwong.org>
 <ADF3DE2C-3BAF-4678-8B9B-7220F3333FE1@dilger.ca>
 <20151204230745.GJ10580@birch.djwong.org>
 <20151204233616.GF18359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbLEBVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 20:21:23 -0500
Content-Disposition: inline
In-Reply-To: <20151204233616.GF18359@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 04, 2015 at 06:36:16PM -0500, Theodore Ts'o wrote:
> On Fri, Dec 04, 2015 at 03:07:45PM -0800, Darrick J. Wong wrote:
> > 
> > Ted took it, but I don't think he's pushed his tree to kernel.org recently.
> 
> I pushed to kernel.org a few days ago, and that patch is there:
> 
> http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?h=next&id=c5b3ae7fb5d58dd12a1e02c2443bad32c8a76150

Ah, fun!  I'll rebase and send a rollup of the pending patches.

(checksum_seed, filefrag, and the two tune2fs things we've been talking about.)

--D

> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
