From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Fri, 26 Feb 2010 19:28:40 -0600
Message-ID: <4B887548.50508@redhat.com>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966806Ab0B0B2r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 20:28:47 -0500
In-Reply-To: <4B887160.2090606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Justin Piszcz wrote:
> ...
> 
>>> Were the filesystems created to align with raid geometry?
>> Only default options were used except the mount options.  If that is the
>> culprit, I have some more testing to do, thanks, will look into it.
>>
>>> mkfs.xfs has done that forever; mkfs.ext4 only will do so (automatically)
>>> with recent kernel+e2fsprogs.
>> How recent?
> 
> You're recent enough.  :)

Oh, you need very recent util-linux-ng as well, and use libblkid from there
with:

[e2fsprogs] # ./configure --disable-libblkid

Otherwise you can just feed mkfs.ext4 stripe & stride manually.

-Eric
