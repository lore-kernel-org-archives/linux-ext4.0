From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: [dm-devel] Re: jbd2 inside a device mapper module
Date: Tue, 30 Dec 2008 11:51:47 -0200
Message-ID: <20081230135147.GP4127@blitiri.com.ar>
References: <20081225143535.GA4127@blitiri.com.ar> <20081227200127.GX5000@webber.adilger.int> <46A00B48CC54E4468EF6911F877AC4CA01DDBB66@blrx3m10.blr.amer.dell.com> <20081229210537.GN4127@blitiri.com.ar> <4959C5FD.3050305@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shyam_Iyer@Dell.com, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, tytso@MIT.EDU,
	linux-kernel@vger.kernel.org
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2713 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYL3Nye (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Dec 2008 08:54:34 -0500
Content-Disposition: inline
In-Reply-To: <4959C5FD.3050305@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 30, 2008 at 09:55:57AM +0300, Alex Tomas wrote:
> one good thing about JBD is that you can't update target block and csum
> atomically. so, either you use some form of COW or you use journalling.
> given we already have JBD it'd make sense to use it?

I'm sorry, but I'm not following. Is that first sentence right?

The main disadvantage I see of using jbd at the moment is that I loose
the possibility of having checksums and data in a different device.

The only alternative to jbd that I have at the moment is the "two
metadatas" approach I explained in another email (but please let me know
if it wasn't clear).

They both provide what I need (atomicity in data and csum writes), one
is easier, more tested, but prevents a feature. The other is a bit more
difficult, untested and written my me, but allows a feature. I have no
idea, performance-wise, how they will behave (it is expected they suck,
according to the other emails).

At this moment I'm going with the two metadatas approach, because I
think it has less limitations and it'd be fun to write. If then it's
unfit for some reason, I can always go back and use jbd. But I'm
obviously open to suggestions and more alternatives.

Thanks a lot,
		Alberto

