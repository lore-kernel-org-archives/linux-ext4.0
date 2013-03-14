From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: mke2fs with bigalloc is too slow
Date: Fri, 15 Mar 2013 01:53:58 +0400
Message-ID: <CAA0+VHx5=hYPOefnA-5eTrwFMtsg4sLujCLB91fGx2eoZrP0+w@mail.gmail.com>
References: <CAA0+VHz9+LpS9jGbTEE_OE9kvgdXDqj3qMQQV5kTTJ12WDxMPg@mail.gmail.com>
	<20130313190016.GE5604@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:38261 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3CNVyB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2013 17:54:01 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2ELuso1024592
	for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2013 17:56:54 -0400 (EDT)
Received: from mail-ia0-f182.google.com (mail-ia0-f182.google.com [209.85.210.182])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2ELurWZ024585
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2013 17:56:54 -0400 (EDT)
Received: by mail-ia0-f182.google.com with SMTP id b35so2588546iac.13
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2013 14:53:58 -0700 (PDT)
In-Reply-To: <20130313190016.GE5604@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 13, 2013 at 11:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Actually, these days we use a rbtree to encode the bitmap.  That means
> that it should be possible to create a very efficient find_first_set
> and find_first_zero functions.  This would work especially well for
> mke2fs since the allocation bitmap will be mostly empty.  This I think
> would improve things dramatically.

Oh, thanks for pointing that! I was mostly reading v1.42 that is more
than year old and missed the fact 1.42.7 has rbtree bitmap
implementation.
That explains why formatting bigalloc became slower compared to 1.42.
In this case ffs/ffz seem like a right choice, I'll try them. I'll
also try mirroring as it won't waste much RAM and might be faster.

> Fragmenting the block allocation bitmaps slows down operations that
> need to read in multiple block bitmaps in sequence.  This includes
> dumpe2fs, e2fsck, and in some cases, block allocation.  So making this
> change is not zero-cost.  I agree that 30 seconds for mke2fs is
> non-optimal, but I'm surprised you're finding this to be a
> showstopper.  I assume you're worried about substantially bigger file
> systems than just 1TB?

1TB is what we have. It is a show stopper because it increases first
boot time a lot compared to total boot time. This is bad because first
boot happens on factory and thus should be as quick as possible.
