From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 15:06:32 -0400
Message-ID: <yq1wrvweklj.fsf@sermon.lab.mkp.net>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	<x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
	<k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
	<alpine.LFD.2.00.1004230944070.2814@localhost>
	<w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>
	<4BD2F69D.7070508@redhat.com>
	<o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>
	<4BD30393.4050800@redhat.com>
	<h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>
	<4BD324B5.4030808@redhat.com>
	<p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:54694 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0DXTG5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2010 15:06:57 -0400
In-Reply-To: <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>
	(Greg Freemyer's message of "Sat, 24 Apr 2010 14:30:54 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> Is it also agreed by all that the current ext4 kernel
Greg> implementation of calling discard is a poor solution for most
Greg> hardware / block layers stacks / workloads and therefore is not
Greg> worth retaining nor performing further benchmarks?

Our discard implementation is meant to accommodate a wide range of
devices.  Just because some of the currently shipping low-end consumer
SSDs implement TRIM poorly does not mean we're going to scrap what we
have.

We are not in the business of designing for the past.  Especially not
when the past can be handled by a shell script.

For future devices TRIM/UNMAP is going to be an inherent part of the
command set.  And that's what our kernel support is aimed at.  There are
some deficiencies right now because the block layer was not built to
handle what is essentially a hybrid between a filesystem and a blk_pc
type request.  I'm working on fixing that.


Greg> I've not seen anyone arguing to keep the current kernel
Greg> implementation and I for one accept the previously posted
Greg> benchmarks that show it is not adding any value relative to the
Greg> traditional non-discard case.

For enterprise storage the cost of sending discards is limited to the
overhead of sending the command.  I.e. negligible.

Eventually that's going to be the case for ATA devices as well.  And let
me just reiterate that Windows 7 does issue TRIM like we do (at
runtime).  And consequently Windows 7 will help weed out the crap SSD
implementations from the market.  That's already happening.

There is also work underway to make TRIM a queueable command which would
further alleviate the situation.


Greg> Therefore benchmarks between the current hdparm/wiper.sh userspace
Greg> implementation and a proposed new kernel implementation would be
Greg> the most beneficial?

I don't know what you mean by "new" kernel implementation.  We're
working on tweaking what we have so that we can split, merge, and
coalesce requests.

I'm also not sure why you're so hung up on benchmarks.  The purpose of
TRIM is to increase longevity of a flash-based device.  For dumb devices
there's currently a tradeoff - do you want speed or endurance?  Once
devices get smarter that tradeoff will disappear.

-- 
Martin K. Petersen	Oracle Linux Engineering
