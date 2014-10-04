From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fast ext4 cleanup to avoid data loss after power failure
Date: Fri, 3 Oct 2014 23:47:07 -0400
Message-ID: <20141004034707.GA4581@thunk.org>
References: <542EA00B.4040401@pqgruber.com>
 <alpine.LFD.2.00.1410031550090.2333@localhost.localdomain>
 <542EC343.7090905@pqgruber.com>
 <542EC445.5030503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Clemens Gruber <clemens.gruber@pqgruber.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36159 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaJDDrN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Oct 2014 23:47:13 -0400
Content-Disposition: inline
In-Reply-To: <542EC445.5030503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So long as you aren't dilly-dallying, 1.5 seconds is an huge amount of
time so long as the application doesn't have to write a huge amount of
state.  What I would do is to give the application a second time
budget to shutdown, then use the FIFREEZE ioctl to lock the file
system into a consistent state, and then wait for the end to come.

More generally, it's a good idea to seriously control how much stuff
you are writing to the eMMC, and to question whether any of it is
necessary, and if it isn't to ruthless cut it out.

In addition to the write everything to a temporary file, and the fsync
the changes, and then use an atomic rename to replace the original
file, an additional design pattern you can use is an application level
journal.  Just append each thing that needs to be saved to an
application journal file: "dispensed one shot of whisky"; "entering
light pour mode for happy hour", etc, with an fsync() after each write
to the application.  This minimizes the amount of writes you need for
each application update, and then periodically, you can dump all of
the state out to the temp file, rename it, and then truncate the
application journal.

If you crash, then it's simply a matter of replaying the application
journal log into your application state when you start up again.

One important thing to remember is that most eMMC are not protected
against power failure.  So if you are writing to the eMMC flash when
the power finally fails, the flash translation metadata can get
corrupted, and you can lose all of your data, or some of your data,
but it will not be under your control at all.

Hence my recommendation to give your application a one second time
budget to quiesce itself, and then to use FIFREEZE --- that way you
don't have to optimize your system daemons from having a fast shutdown
sequence.  Or you can have your emergency shutdown program send a kill
-9 to all processes except itself and init, and then unmount the file
system --- but FIFREEZE might be easier.  :-)

Cheers,

						- Ted

P.S.  And keeping a read-only root and only having writable state in
small writable partition is also a good idea.  For bonus points, keep
*two* copies of the read-only root, so you can update one of the
roots, reboot into it, and if you can successfuly reboot into it, only
then do you update the other read-only root.
