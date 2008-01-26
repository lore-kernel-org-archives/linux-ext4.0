From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Sat, 26 Jan 2008 16:17:24 +1100
Message-ID: <20080126051724.GM155407@sgi.com>
References: <20080125195938t-sato@mail.jp.nec.com> <84144f020801250317pbdafc4fnd47cc8a297194e86@mail.gmail.com> <001c01c85f4f$bfd128f0$41a8400a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57258 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbYAZFRv (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Sat, 26 Jan 2008 00:17:51 -0500
Content-Disposition: inline
In-Reply-To: <001c01c85f4f$bfd128f0$41a8400a@bsd.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2008 at 09:42:30PM +0900, Takashi Sato wrote:
> >I am also wondering whether we should have system call(s) for these:
> >
> >On Jan 25, 2008 12:59 PM, Takashi Sato <t-sato@yk.jp.nec.com> wrote:
> >>+       case EXT3_IOC_FREEZE: {
> >
> >>+       case EXT3_IOC_THAW: {
> >
> >And just convert XFS to use them too?
> 
> I think it is reasonable to implement it as the generic system call, as you
> said.  Does XFS folks think so?

Sure.

Note that we can't immediately remove the XFS ioctls otherwise
we'd break userspace utilities that use them....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
