From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Ext4: batched discard support - simplified version
Date: Mon, 26 Jul 2010 12:30:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007261209310.2905@localhost>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com> <20100723143604.GF13090@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, eshishki@redhat.com,
	jmoyer@redhat.com, rwheeler@redhat.com, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0GZKae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jul 2010 06:30:34 -0400
In-Reply-To: <20100723143604.GF13090@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 23 Jul 2010, Ted Ts'o wrote:

> On Wed, Jul 07, 2010 at 09:53:30AM +0200, Lukas Czerner wrote:
> > 
> > Hi all,
> > 
> > since my last post I have done some more testing with various SSD's and the
> > trend is clear. Trim performance is getting better and the performance loss
> > without trim is getting lower. So I have decided to abandon the initial idea
> > to track free blocks within some internal data structure - it takes time and
> > memory.
> 
> Do you have some numbers about how bad trim actually might be on
> various devices?  I can imagine some devices where it might be better
> (for wear levelling and better write endurance if nothing else) where
> it's better to do the trim right away instead of batching things.

Hi,

Yes, I have those numbers.

http://people.redhat.com/jmoyer/discard/ext4_batched_discard/ext4_discard.html
This page presents my test results on three different devices. I have
tested the current ext4 discard implementation (do the trim right away).
However, one tested device is still not on that page. With this
(Vendor4) device I have got only about 1.83% performance loss, which is
very good.

http://people.redhat.com/jmoyer/discard/ext4_batched_discard/ext4_ioctltrim.html
This page provides test results with my batched discard implementation.
Take those numbers with discretion, because the patch still does not
involve journaling and I have tested the "worst case" scenario, which
involves issuing FITRIM in endless loop without any sleep.

Generally the FITRIM ioctl can take from 2 seconds on fast devices to
several (2-4) minutes on very slow devices, or under heavy load.


> 
> So what I'm thinking about doing is keeping the "discard" mount option
> to mean non-batched discard.  If you want to use the explicit FITRIM
> ioctl, I don't think we need to test to see if the dicard mount option
> is set; if the user issues the ioctl, then we should do the batched
> discard, and if we don't trust the user to do that, then well, the
> ioctl should be restricted to privileged users only --- especially if
> it could take up to a minute.

I agree.

> 
> 						- Ted
> 

Thanks.

-Lukas
