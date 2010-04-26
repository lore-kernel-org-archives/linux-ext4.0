From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 11:48:57 -0400
Message-ID: <4BD5B5E9.3030206@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	<x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>	<k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>	<alpine.LFD.2.00.1004230944070.2814@localhost>	<w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>	<4BD2F69D.7070508@redhat.com>	<o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>	<4BD30393.4050800@redhat.com>	<h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>	<4BD324B5.4030808@redhat.com>	<p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>	<4BD33B61.2080807@redhat.com> <4BD59C84.4040200@teksavvy.com> <yq18w8ae0mq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mark Lord <kernel@teksavvy.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab0DZPpg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 11:45:36 -0400
In-Reply-To: <yq18w8ae0mq.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/26/2010 10:42 AM, Martin K. Petersen wrote:
>>>>>> "Mark" == Mark Lord<kernel@teksavvy.com>  writes:
>
> Mark>  So.. again.. in an ideal kernel, I'd like to see use of larger
> Mark>  ranges (and _multiple_ ranges) per TRIM command.  And options for
> Mark>  the kernel to do it automatically (-o discard), as well as an
> Mark>  ioctl() interface for userspace to "scrub" (or "wipe") all free
> Mark>  ranges in a gradual fashion.
>
> Again: Discard splitting, merging, and coalescing is coming.  I'm
> working on it.  It's not exactly trivial.
>
> My objection was purely wrt. nuking realtime discard in favor of
> scrubbing.  We absolutely need both approaches.
>
> But I'm not going to let crappy SSD firmware implementations set the
> direction for what I'm working on.  It is much more interesting to
> ensure that we work well for the devices that'll be shipping 6-12 months
> from now (at the time where this stuff will realistically end up in
> distro kernels).
>

And one thing to keep in mind is that we are likely to need both run time 
support for discard as well as occasional resync in bulk since the storage can 
choose to ignore the command and still be in spec.  Kind of like the unfortunate 
"defrag" thing that windows people do,

ric
