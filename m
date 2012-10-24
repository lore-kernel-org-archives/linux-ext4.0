From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 17:31:29 -0400
Message-ID: <20121024213129.GB5484@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <20121023221913.GC28626@thunk.org>
 <k69ejs$vt2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Jannis Achstetter <jannis_achstetter@web.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <k69ejs$vt2$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 24, 2012 at 09:13:01PM +0200, Jannis Achstetter wrote:
> 
> As a "normal linux user" I'm interested in the practical things to do
> now to avoid data loss. I'm running several systems with 3.6.2 and ext4.
> Fearing loss of data:
> - Is there a way to see whether the journal of a specific partition has
> been wrapped (since mounting) so that umounting and mounting (or doing a
> reboot to downgrade the kernel) is safe?

My initial analysis of what had been causing the problem now looks
incorrect (or at least incomplete).  Both Eric and I have been unable
to reproduce the failure based on my initial theory of what had been
going on.  So the best information at this point is that it's probably
not related to the file system getting unmounted before the journal
has wrapped.

(Keep in mind this is why commercial software corporations like
Microsoft or Apple generally don't make discussions as they are trying
to root cause a problem public; sometimes the initial theories can be
incorrect, and it's unfortunate when misinformation ends up on
Phoronix or Slashdot, leading to people to panic...  but this is open
source, so that means we do everything in the open, since that way we
can all work towards finding the best answer.)

At the *moment* it looks like it might be related to an unclean
shutdown (i.e., a forced reset or power failure while the file system
is mounted or is in the process of being unmounted).  That being said,
a simply kill -9 of kvm running a test kernel while the file system is
mounted by otherwise quiscient doesn't trigger the problem (I was
trying that last night).

It's a little bit too early for this meme:

    http://memegenerator.net/instance/28936247

But do please note that that Fedora !7 users have been using 3.6.2 for
a while, so if this were an easily triggered bug, (a) Eric and I would
have managed to reproduce it by now, and (b) lots of people would be
complaining, since the symptoms of the bug are not subtle.

That's not to say we aren't treating this seriously; but people
shouldn't panic unduly.... (and if you are using a critical
enterprise/production server on bleeding edge kernels, may I suggest
that this might not be such a good idea; there is a *reason* why
enterprise Linux distro's spend 6-9 months or more just stablizing the
kernel, and being super paranoid about making changes afterwards for
years, and it's not because they enjoy backporting patches and working
with trailing edge kernel sources.  :-)

Regards,

						- Ted
