From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Date: Mon, 7 Mar 2016 00:26:12 -0800
Message-ID: <20160307082612.GE22185@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003837.28738.49794.stgit@birch.djwong.org>
 <20160305182508.GA25528@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33193 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbcCGI0x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Mar 2016 03:26:53 -0500
Content-Disposition: inline
In-Reply-To: <20160305182508.GA25528@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 10:25:08AM -0800, Christoph Hellwig wrote:
> I'm not sure xfstests is the right fit, as it does not test a file
> system, but rather block devices.

I asked Dave if he'd take a fallocate-for-bdevs test, and he didn't
object.  After all, we're testing a semi-standard FS API, just with
block devices.

> If people think it should go into xfstests we should at least not
> add it to the default group, but just to a new bdev group.

Sure, I don't mind changing the group to 'bdev' or something.

--D
