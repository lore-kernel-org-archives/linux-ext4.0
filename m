From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount)
Date: Thu, 25 Oct 2012 00:27:02 +0100
Message-ID: <87y5iv78op.fsf_-_@spindle.srvr.nix>
References: <20121023013343.GB6370@fieldses.org>
	<87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:35583 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2JXX1Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 19:27:16 -0400
In-Reply-To: <20121024210819.GA5484@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 17:08:19 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Theodore Ts'o verbalised:

> On Wed, Oct 24, 2012 at 09:45:47PM +0100, Nix wrote:
>> 
>> It occurs to me that it is possible that this bug hits only those
>> filesystems for which a umount has started but been unable to complete.
>> If so, this is a relatively rare and unimportant bug which probably hits
>> only me and users of slow removable filesystems in the whole world...
>
> Can you verify this?  Does the bug show up if you just hit the power
> switch while the system is booted?

Verified! You do indeed need to do passing strange things to trigger
this bug -- not surprising, really, or everyone and his dog would have
reported it by now. As it is, I'm sorry this hit slashdot, because it
reflects unnecessarily badly on a filesystem that is experiencing
problems only when people do rather insane things to it.

> How about changing the "sleep 2" to "sleep 0.5"?

I tried the following:

 - /sbin/reboot -f of running system
   -> Journal replay, no problems other than the expected free block
      count problems. This is not such a severe problem after all!

 - Normal shutdown, but a 60 second pause after lazy umount, more than
   long enough for all umounts to proceed to termination
   -> no corruption, but curiously /home experienced a journal replay
      before being fscked, even though a cat of /proc/mounts after
      umounting revealed that the only mounted filesystem was /,
      read-only, so /home should have been clean

 - Normal shutdown, a 60 second pause after lazy umount of everything
   other than /var, and then a umount of /var the instant before
   reboot, no sleep at all
   -> massive corruption just as seen before.

Unfortunately, the massive corruption in the last testcase was seen in
3.6.1 as well as 3.6.3: it appears that the only effect that superblock
change had in 3.6.3 was to make this problem easier to hit, and that the
bug itself was introduced probably somewhere between 3.5 and 3.6 (though
I only rebooted 3.5.x twice, and it's rare enough before 3.6.[23], at
~1/20 boots, that it may have been present for longer and I never
noticed).

So the problem is caused by rebooting or powering off or disconnecting
the device *while* umounting a filesystem with a dirty journal, and
might have been introduced by I/O scheduler changes or who knows what
other changes, not just ext4 changes, since the order of block writes by
umount is clearly at issue.

Even though my own system relies on the possibility of rebooting during
umount to reboot reliably, I'd be inclined to say 'not a bug, don't do
that then' -- except that this renders it unreliable to use umount -l to
unmount all the filesystems you can, skipping those that are not
reachable due to having unresponsive servers in the way. As far as I can
tell, there is *no* way to tell when a lazy umount has completed, except
perhaps for polling /proc/mounts: and there is no way at all to tell
when a lazy umount switches from 'waiting for the last process to stop
using me, you can reboot without incident' to 'doing umount, rebooting
is disastrous'. And unfortunately I want to reboot if we're in the
former state, but not in the latter.

(It also makes it unreliable to use ext4 on devices like USB sticks that
might suddenly get disconnected during a umount.)


Further, it seems to me that this makes it dangerous to ever use umount
-l at all, even during normal system operation, since the real umount
might only start when all processes are killed at system shutdown, and
the reboot could well kick in before the umount has finished.

It also appears impossible for me to reliably shut my system down,
though a 60s timeout after lazy umount and before reboot is likely to
work in all but the most pathological of cases (where a downed NFS
server comes up at just the wrong instant): it is clear that the
previous 5s timeout eventually became insufficient simply because of the
amount of time it can take to do a umount on today's larger filesystems.

Truly, my joy is unbounded :(

> 0) Make sure the reliable repro does _not_ work with 3.6.1 booted

Oh dear. Sorry :(((

I can try to bisect this and track down which kernel release it appeared
in -- if it isn't expected behaviour, of course, which is perfectly
possible: rebooting during a umount is at best questionable. But I can't
do anything that lengthy before the weekend, I'm afraid.

-- 
NULL && (void)
