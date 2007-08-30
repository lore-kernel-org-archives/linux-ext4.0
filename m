From: Nathan Scott <nscott@aconex.com>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Fri, 31 Aug 2007 08:42:31 +1000
Message-ID: <1188513751.24970.109.camel@edge.yarra.acx>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	 <1188457666.24970.94.camel@edge.yarra.acx>
	 <20070830132002.GA4086@infradead.org>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Jeffrey W. Baker" <jwbaker@acm.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.app.aconex.com ([203.89.192.138]:43589 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757230AbXH3WlU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 18:41:20 -0400
In-Reply-To: <20070830132002.GA4086@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[culled zfs-discuss from CC, since its subscriber-only]

On Thu, 2007-08-30 at 14:20 +0100, Christoph Hellwig wrote:
> 
> On Thu, Aug 30, 2007 at 05:07:46PM +1000, Nathan Scott wrote:
> > To improve metadata performance, you have many options with XFS
> (which
> > ones are useful depends on the type of metadata workload) - you can
> try
> > a v2 format log, and mount with "-o logbsize=256k", try increasing
> the
> > directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the
> log
> > size (mkfs.xfs -lsize=XXXXXXb).
> 
> Okay, these suggestions are one too often now.  v2 log and large
> logs/log
> buffers are the almost universal suggestions, and we really need to
> make
> these defaults.

Possibly.  Far more importantly for XFS, there really needs to be some
way for RAID drivers to say "even though I support write barriers, its
not a good idea for filesystems to enable write barriers by default on
me".  Enabling write barriers everywhere, by default, seems to have a
far worse impact than any mkfs/mount option tweaking.

>   XFS is already the laughing stock of the Linux community
> due to it's absurdely bad default settings.

Oh, _thats_ what everyone's laughing at?

cheers.

--
Nathan
