From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6
 (when rebooting during umount)
Date: Wed, 24 Oct 2012 21:10:56 -0400
Message-ID: <20121025011056.GC4559@thunk.org>
References: <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508740B2.2030401@redhat.com>
 <87txtkld4h.fsf@spindle.srvr.nix>
 <50876E1D.3040501@redhat.com>
 <20121024052351.GB21714@thunk.org>
 <878vavveee.fsf@spindle.srvr.nix>
 <20121024210819.GA5484@thunk.org>
 <87y5iv78op.fsf_-_@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57359 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2JYBLO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2012 21:11:14 -0400
Content-Disposition: inline
In-Reply-To: <87y5iv78op.fsf_-_@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 25, 2012 at 12:27:02AM +0100, Nix wrote:
>
>  - /sbin/reboot -f of running system
>    -> Journal replay, no problems other than the expected free block
>       count problems. This is not such a severe problem after all!
> 
>  - Normal shutdown, but a 60 second pause after lazy umount, more than
>    long enough for all umounts to proceed to termination
>    -> no corruption, but curiously /home experienced a journal replay
>       before being fscked, even though a cat of /proc/mounts after
>       umounting revealed that the only mounted filesystem was /,
>       read-only, so /home should have been clean

Question: how are you doing the journal replay?  Is it happening as
part of running e2fsck, or are you mounting the file system and
letting kernel do the journal replay?

Also, can you reproduce the problem with the nobarrier and
journal_async_commit options *removed*?  Yes, I know you have battery
backup, but it would be interesting to see if the problem shows up in
the default configuration with none of the more specialist options.
(So it would probably be good to test with journal_checksum removed as
well.)

If that does make the problem go away, that will be a very interesting
data point....

> Unfortunately, the massive corruption in the last testcase was seen in
> 3.6.1 as well as 3.6.3: it appears that the only effect that superblock
> change had in 3.6.3 was to make this problem easier to hit, and that the
> bug itself was introduced probably somewhere between 3.5 and 3.6 (though
> I only rebooted 3.5.x twice, and it's rare enough before 3.6.[23], at
> ~1/20 boots, that it may have been present for longer and I never
> noticed).

Hmm.... ok.  Can you tell whether or not the 2nd patch I posted on
this thread made any difference to how frequently it happened?  The
main difference with 3.6.3 with 2nd patch applied compared to 3.6.1 is
that if it detects that the journal superblock update is a no-op, it
skips the write request.  With 3.6.1, it submits the journal
superblock write regardless of whether or not it would be a no-op.  So
if my patch isn't making a difference to the freqency to when you are
seeing the corruption, then it must be the write request itself which
is important.

When you say it's rare before 3.6.[23], how rare is it?  How reliably
can you trigger it under 3.6.1?  One in 3?  One in 5?  One in 20?

As far as bisecting, one experiment that I'd really appreciate your
doing is to check and see whether you can reproduce the problem using
the 3.4 kernel, and if you can, to see if it reproduces under the 3.3
kernel.

The reason why I ask this is there were not any major changes between
3.5 and 3.6, or between 3.4 and 3.5.  There *were* however, some
fairly major changes made by Jan Kara that were introduced between 3.3
and 3.4.  Among other things, this is where we started using FUA
(Force Unit Attention) writes to update the journal superblock instead
of just using REQ_FLUSH.  This is in fact the most likely place where
we might have introduced the regression, since it wouldn't surprise me
if Jan didn't test the case of using nobarrier with a storage array
with battery backup (I certainly didn't, since I don't have easy
access to such fancy toys :-).

> It also appears impossible for me to reliably shut my system down,
> though a 60s timeout after lazy umount and before reboot is likely to
> work in all but the most pathological of cases (where a downed NFS
> server comes up at just the wrong instant): it is clear that the
> previous 5s timeout eventually became insufficient simply because of the
> amount of time it can take to do a umount on today's larger filesystems.

Something that you might want to consider trying is after you kill all
of the processes, remount all of the local disk file systems
read-only, then kick off the unmount of the NFS file systems (just to
be nice to the NFS servers, so they are notified of the unmount), and
then just force the reboot.  If the file systems have been remounted
r/o, that will cause the journal to be shutdown cleanly, and all of
the write flushed out.  (Modulo issues with nobarrier, but that's a
separate issue.  I'm now thinking that a smart thing to do might be
force a flush on an unmount or remount r/o, regardless of whether
nobarrier is specified, just to make sure everything is written out
before the poweroff, battery backup or no.)

Regards,

						- Ted
