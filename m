From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes (v2)
Date: Mon, 26 Sep 2011 00:10:50 +0200
Message-ID: <201109260010.50649.rjw@sisk.pl>
References: <4E1C70AD.1010101@u-club.de> <201109251532.20025.rjw@sisk.pl> <4E7FA3C7.5050503@u-club.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>,
	Nigel Cunningham <nigel@tuxonice.net>,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Christoph <cr2005@u-club.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:55055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1IYWIj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Sep 2011 18:08:39 -0400
In-Reply-To: <4E7FA3C7.5050503@u-club.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday, September 25, 2011, Christoph wrote:
> On 25.09.2011 15:32, Rafael J. Wysocki wrote:
> > On Sunday, September 25, 2011, Christoph wrote:
> >> test results of the patch below:
> >> 
> >> 1. real machine
> >> 
> >> suspends fine but on wakeup, after loading image: hard reset. nvidia
> >> gpu => disabled compitz  => wakeup worked two times.
> > 
> > Hmm, so there's a separate bug related to NVidia I guess.
> 
> Maybe.
> 
> Just made another test: the machine (macbook) woke up, loaded image, thaw.
> It got stuck at vt#1, displaying console with login. Cursor blinking, but
> no (usb) keyboard or network enabled. Bricked?!!
> 
> 
> On the other hand I've got another box with nvidia gpu:
> 
> debian5 32bit
> 2.6.38.2+ #3 SMP Fri Apr 1
> nvidia 260.19.36
> 
> It's up since I compiled the kernel: I use it twice a week and I kept it
> freezed all the time. It was solid rock until today: hard reset on resume.
> WTF? (I remember this version combo was stable on the macbook but the
> kernel lacks a solid wireless driver).

If that's an x86_64 system, there is a known bug causing problems like
this to happen.  There's a patch fixing it, but not conclusive:
http://marc.info/?l=linux-kernel&m=131653513414314&w=2

Thanks,
Rafael
