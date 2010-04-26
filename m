From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 10:42:21 -0400
Message-ID: <yq18w8ae0mq.fsf@sermon.lab.mkp.net>
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
	<4BD33B61.2080807@redhat.com> <4BD59C84.4040200@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:28274 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0DZOnK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Apr 2010 10:43:10 -0400
In-Reply-To: <4BD59C84.4040200@teksavvy.com> (Mark Lord's message of "Mon, 26
	Apr 2010 10:00:36 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> So.. again.. in an ideal kernel, I'd like to see use of larger
Mark> ranges (and _multiple_ ranges) per TRIM command.  And options for
Mark> the kernel to do it automatically (-o discard), as well as an
Mark> ioctl() interface for userspace to "scrub" (or "wipe") all free
Mark> ranges in a gradual fashion.

Again: Discard splitting, merging, and coalescing is coming.  I'm
working on it.  It's not exactly trivial.

My objection was purely wrt. nuking realtime discard in favor of
scrubbing.  We absolutely need both approaches.

But I'm not going to let crappy SSD firmware implementations set the
direction for what I'm working on.  It is much more interesting to
ensure that we work well for the devices that'll be shipping 6-12 months
from now (at the time where this stuff will realistically end up in
distro kernels).

-- 
Martin K. Petersen	Oracle Linux Engineering
