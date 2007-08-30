From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 14:20:02 +0100
Message-ID: <20070830132002.GA4086@infradead.org>
References: <1188454611.23311.13.camel@toonses.gghcwest.com> <1188457666.24970.94.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jeffrey W. Baker" <jwbaker@acm.org>, zfs-discuss@opensolaris.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Nathan Scott <nscott@aconex.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57972 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXH3NUP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:20:15 -0400
Content-Disposition: inline
In-Reply-To: <1188457666.24970.94.camel@edge.yarra.acx>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2007 at 05:07:46PM +1000, Nathan Scott wrote:
> To improve metadata performance, you have many options with XFS (which
> ones are useful depends on the type of metadata workload) - you can try
> a v2 format log, and mount with "-o logbsize=256k", try increasing the
> directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the log
> size (mkfs.xfs -lsize=XXXXXXb).

Okay, these suggestions are one too often now.  v2 log and large logs/log
buffers are the almost universal suggestions, and we really need to make
these defaults.  XFS is already the laughing stock of the Linux community
due to it's absurdely bad default settings.
