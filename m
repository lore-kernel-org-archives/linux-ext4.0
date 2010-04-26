From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 10:03:37 -0400
Message-ID: <4BD59D39.5050906@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	<x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>	<k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>	<alpine.LFD.2.00.1004230944070.2814@localhost>	<w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>	<4BD2F69D.7070508@redhat.com>	<o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>	<4BD30393.4050800@redhat.com>	<h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>	<4BD324B5.4030808@redhat.com>	<p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com> <yq1wrvweklj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:65285 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752575Ab0DZOGt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Apr 2010 10:06:49 -0400
In-Reply-To: <yq1wrvweklj.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24/04/10 03:06 PM, Martin K. Petersen wrote:
..
> Our discard implementation is meant to accommodate a wide range of
> devices.  Just because some of the currently shipping low-end consumer
> SSDs implement TRIM poorly does not mean we're going to scrap what we
> have.
..

The current implementation works extremely poorly for the singlemost
common style of hardware that's out there.  Millions and millions
of SATA SSDs, and they're becoming more and more ubiquitous.

A "solution" that ignores reality isn't very helpful.
We can do better than that, a lot better.

> We are not in the business of designing for the past.  Especially not
> when the past can be handled by a shell script.
..

We are in the business of supporting the hardware that people run Linux on.
Today, and tomorrow, and the next few years, that means SATA SSDs by the gazillions,
as well as a relatively smaller number of enterprise behemoths.

A shell script cannot currently deal with LVM, RAID, or btrfs filesystems.

Cheers
