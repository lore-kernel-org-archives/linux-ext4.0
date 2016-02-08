From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Date: Mon, 8 Feb 2016 10:22:00 +0100
Message-ID: <20160208092200.GA31881@lst.de>
References: <1454524816-11392-1-git-send-email-hch@lst.de> <1454524816-11392-3-git-send-email-hch@lst.de> <20160208010026.GL31407@dastard> <20160208061731.GC27429@dastard> <20160208073121.GA30092@lst.de> <20160208091644.GD27429@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60434 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbcBHJWD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2016 04:22:03 -0500
Content-Disposition: inline
In-Reply-To: <20160208091644.GD27429@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 08, 2016 at 08:16:44PM +1100, Dave Chinner wrote:
> I can't tell if you are saying what I've done is fine if the
> xfs-dio-fix-4.6 branch is stable (so others can pull it) or whether
> it should be in some other tree. Can you clarify, Christoph?

What you are doing is fine, thanks!
