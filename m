From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic question: user-only directory w/o root access
Date: Fri, 5 Jun 2015 20:33:23 -0400
Message-ID: <20150606003323.GC26550@thunk.org>
References: <mkfbkb$fo1$1@ger.gmane.org>
 <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org>
 <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org>
 <20150605141429.GA26550@thunk.org>
 <mkst24$nbb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50538 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbbFFAd3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 20:33:29 -0400
Content-Disposition: inline
In-Reply-To: <mkst24$nbb$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 05, 2015 at 09:24:51PM +0200, U.Mutlu wrote:
> true, the dangers and challenges are high. The solution I finally
> found took me unfortunately a long time to find it, and I know of
> no other open-source solution to achieve what I described,
> because of the unfortunate 'root is king and user is nobody' mentality
> and reality we have.
> But as described, in some security environments the user needs
> a truly private space on the system where nobody else has access to.

"where nobody else has access" is impossible on a shared system.
Period.  There reason why there is no other open-source solution is
because there *is* no open source solution, period.  You can't have an
open source solution that perfromances something which is by
definition impossible.

If someone needs truly private space, the only thing they can do is to
use their own hardware, purcahsed at a computer store, and then to use
a system like Tails[1] booted from a read-only USB stick.

[1] https://tails.boum.org/

... and even then they have to trust the people who implemented the
Tails system, and the people who implemented the firmware on the
computer system, and if the system was shipped to you, you have to
trust that the NSA hasn't intercepted the hardware and compromised the
hardware.

[2] http://arstechnica.com/tech-policy/2014/05/photos-of-an-nsa-upgrade-factory-show-cisco-router-getting-implant/

> I think the filesystem could indeed implement such a "user-only" directory,
> because the FUSE-API wrapper showed me that it is indeed possible
> to implement that idea. I would suggest to add this feature to ext4,
> and that new feature could be a real game-changer (yes, I know another
> bold statement) in IT security.

Sorry, I'm not willing to advertise that a file system has a feature
which is a pure snake oil --- someone claiming that this can be done
is making a fradulently untrue statement.

Regards,

						- Ted
