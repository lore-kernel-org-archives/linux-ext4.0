From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 10:00:36 -0400
Message-ID: <4BD59C84.4040200@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>	 <alpine.LFD.2.00.1004230944070.2814@localhost>	 <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>	 <4BD2F69D.7070508@redhat.com>	 <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>	 <4BD30393.4050800@redhat.com>	 <h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>	 <4BD324B5.4030808@redhat.com> <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com> <4BD33B61.2080807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:38857 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290Ab0DZOKP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Apr 2010 10:10:15 -0400
In-Reply-To: <4BD33B61.2080807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24/04/10 02:41 PM, Ric Wheeler wrote:
..
> I don't like the user space wiper.sh approach in general, but running
> wiper.sh is entirely your choice.
>
> Most users prefer having the file system and the IO stack take care of
> this for them, but again, entirely configurable.
..

I wrote wiper.sh, and I would prefer more of an in-kernel solution,
simply because it could potentially have the smarts to deal with RAID,
LVM, and btrfs's own duplicate implementation of RAID/LVM.

Those cannot be done from userspace on a mounted filesystem.

So.. again.. in an ideal kernel, I'd like to see use of larger ranges
(and _multiple_ ranges) per TRIM command.  And options for the kernel
to do it automatically (-o discard), as well as an ioctl() interface
for userspace to "scrub" (or "wipe") all free ranges in a gradual fashion.

Cheers

