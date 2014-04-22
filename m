From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Date: Tue, 22 Apr 2014 11:28:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404221127240.7437@localhost.localdomain>
References: <20140421204023.GB960@wallace> <20140422062816.GB31337@infradead.org> <20140422091443.GG15995@dastard> <20140422091620.GA4980@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbaDVJ3D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2014 05:29:03 -0400
In-Reply-To: <20140422091620.GA4980@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Apr 2014, Christoph Hellwig wrote:

> Date: Tue, 22 Apr 2014 02:16:20 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
>     xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>
> Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
> 
> On Tue, Apr 22, 2014 at 07:14:43PM +1000, Dave Chinner wrote:
> > I don't really care either way, as long as all the checks are done
> > consistently. Send a patch to change them all... :)
> 
> My flink test already avoids the wrapper :)
> 
> So how about we stop adding them for now at least.

I agree,

even though I screwed up when using _require_xfs_io_command with
fzero :) I think that we can avoid the wrappers and just use
_require_xfs_io_command() with the command name.

-Lukas

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
