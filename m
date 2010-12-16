From: Chris Mason <chris.mason@oracle.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt barrier support is effective)
Date: Thu, 16 Dec 2010 07:29:58 -0500
Message-ID: <1292502095-sup-3835@think>
References: <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com> <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com> <1291751698-sup-9297@think> <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com> <1291754340-sup-1631@think> <AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com> <1291755258-sup-8760@think> <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com> <1291810586-sup-8211@think> <20101216033718.GM9925@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:19828 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0LPMbC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Dec 2010 07:31:02 -0500
In-reply-to: <20101216033718.GM9925@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Dave Chinner's message of 2010-12-15 22:37:18 -0500:
> On Wed, Dec 08, 2010 at 07:20:24AM -0500, Chris Mason wrote:
> > 
> > Usually the trick to reproducing filesystem corruptions is adding memory
> > pressure.  The corruption is probably a bad interaction between reads
> > and writes, and we need to make sure the reads actually happen.
> > 
> > http://oss.oracle.com/~mason/pin_ram.c
> > 
> > gcc -Wall -o pin_ram pin_ram.c
> > 
> > pin_ram -m 80%-of-your-ram-in-mb
> 
> Implemented in xfstests about 10 years ago:
> 
> http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=blob;f=src/usemem.c;h=b8794a6b209cebf8dbf312a8ef131e2e54b18d29;hb=HEAD

But mine can use shm! I don't remember adding it, so it must have grown
there while it sat on the oracle servers.  Our own special Christmas
magic.

-chris
