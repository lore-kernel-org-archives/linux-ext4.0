From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible ext4 race situation freezing linux
Date: Tue, 24 Feb 2009 12:30:31 -0500
Message-ID: <20090224173031.GE5482@mit.edu>
References: <1235478142.11758.9.camel@localhost.localdomain> <20090224141749.GC5482@mit.edu> <49A41469.6090604@redhat.com> <1235495013.11758.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41566 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189AbZBXRak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 12:30:40 -0500
Content-Disposition: inline
In-Reply-To: <1235495013.11758.37.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 06:03:33AM +1300, Andreas Friedrich Berendsen wrote:
> Tso & Eric,
> 
> I'll try again to reproduce the error, but when the system freezes, I
> have the X interface running. And, indeed, I'm not familiar with the
> behaviour of sysreq. Which sysrq should I use when the problem happens?
> Will the system change to the text interface? If there are no disk
> activity (all leds are off), where the information will be recorded?

Well, given that you can reproduce it fairly reliably, can't you just
switch to a text console using before triggering your reproduction
case?  You can use different VT consules, switching between them using
Alt-F2, Alt-F3, Alt-F2, Alt-F4, etc., instead of using different
terminal windows.

Depending on how badly system is wedged, it may not be possible to
record the information to disk.  Usually what folks will do is use a
digital camera and record snapshots from the text console, or, if they
have a serial console set up, they can record output on another
machine.  A serial console has the advantage that you can reliably
capture the entire sysrq output (you send a serial break character
instead of using the sysrq key) and it also works even if you have X
running.  As such, it's the preferred method, but it's a bit of a pain
for most people to set up, and some modern laptops no longer have 8250
serial ports any more, so we make do with what we have.

Regards,

							- Ted
