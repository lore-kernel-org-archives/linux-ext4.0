From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 223 - test file alignment on stripe geometry
Date: Sat, 30 Jan 2010 14:09:35 -0500
Message-ID: <20100130190935.GB10181@infradead.org>
References: <4B621529.20708@sandeen.net> <20100130105236.GA18286@infradead.org> <4B645AB9.8050508@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0A3TJg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 14:09:36 -0500
Content-Disposition: inline
In-Reply-To: <4B645AB9.8050508@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> didn't break anything for me; I wanted to be able to see the mkfs
> results w/ geometry, is all.  Will re-double-check but it was fine AFAIK.

Yeah, doesn't seem to cause any problems with a full xfsqa run for me.

> > This is a bit misnamed as it's not a generic fibmap tool but rather
> > a specific tool comparing the bmap to the sunit alignment.
> > 
> 
> good point .. how about making it more generic, something like:
> 
> fibmap -o <file offset> -l <length> -s <stripe alignment> <filename>
> 
> hmm though I hate to reqwrite filefrag ... :)
> 
> I suppose something like this could go into xfs_io as well, but that
> makes this test unavailable to the masses until another release, at least.

I'd just leave it as is but call it t_stripealign or similar.

