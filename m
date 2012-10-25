From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount)
Date: Thu, 25 Oct 2012 02:45:57 +0100
Message-ID: <87y5iv5noq.fsf@spindle.srvr.nix>
References: <20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org> <87y5iv78op.fsf_-_@spindle.srvr.nix>
	<20121025011056.GC4559@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:33008 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2JYBqL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 21:46:11 -0400
In-Reply-To: <20121025011056.GC4559@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 21:10:56 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 25 Oct 2012, Theodore Ts'o stated:

> On Thu, Oct 25, 2012 at 12:27:02AM +0100, Nix wrote:
>>
>>  - /sbin/reboot -f of running system
>>    -> Journal replay, no problems other than the expected free block
>>       count problems. This is not such a severe problem after all!
>>=20
>>  - Normal shutdown, but a 60 second pause after lazy umount, more th=
an
>>    long enough for all umounts to proceed to termination
>>    -> no corruption, but curiously /home experienced a journal repla=
y
>>       before being fscked, even though a cat of /proc/mounts after
>>       umounting revealed that the only mounted filesystem was /,
>>       read-only, so /home should have been clean
>
> Question: how are you doing the journal replay?  Is it happening as
> part of running e2fsck, or are you mounting the file system and
> letting kernel do the journal replay?

This most recent instance was e2fsck. Normally, it's mount. Both
seem able to yield the same corruption.

> Also, can you reproduce the problem with the nobarrier and
> journal_async_commit options *removed*?  Yes, I know you have battery
> backup, but it would be interesting to see if the problem shows up in
> the default configuration with none of the more specialist options.
> (So it would probably be good to test with journal_checksum removed a=
s
> well.)

I'll try that, hopefully tomorrow sometime. It's 2:30am now and probabl=
y
time to sleep.

>> Unfortunately, the massive corruption in the last testcase was seen =
in
>> 3.6.1 as well as 3.6.3: it appears that the only effect that superbl=
ock
>> change had in 3.6.3 was to make this problem easier to hit, and that=
 the
>> bug itself was introduced probably somewhere between 3.5 and 3.6 (th=
ough
>> I only rebooted 3.5.x twice, and it's rare enough before 3.6.[23], a=
t
>> ~1/20 boots, that it may have been present for longer and I never
>> noticed).
>
> Hmm.... ok.  Can you tell whether or not the 2nd patch I posted on
> this thread made any difference to how frequently it happened?  The

Well, I had a couple of reboots without corruption with that patch
applied, and /home was only ever corrupted with it not applied -- but
that could perfectly well be chance, since I only had two or three
instances of /home corruption so far, thank goodness.

> When you say it's rare before 3.6.[23], how rare is it?  How reliably
> can you trigger it under 3.6.1?  One in 3?  One in 5?  One in 20?

I've rebooted out of 3.6.1 about fifteen times so far. I've seen once
instance of corruption. I've never seen it before 3.6, but I only
rebooted 3.5.x or 3.4.x once or twice in total, so that too could be
chance.

> As far as bisecting, one experiment that I'd really appreciate your
> doing is to check and see whether you can reproduce the problem using
> the 3.4 kernel, and if you can, to see if it reproduces under the 3.3
> kernel.

Will try. It might be the weekend before I can find the time though :(

> The reason why I ask this is there were not any major changes between
> 3.5 and 3.6, or between 3.4 and 3.5.  There *were* however, some
> fairly major changes made by Jan Kara that were introduced between 3.=
3
> and 3.4.  Among other things, this is where we started using FUA
> (Force Unit Attention) writes to update the journal superblock instea=
d
> of just using REQ_FLUSH.  This is in fact the most likely place where
> we might have introduced the regression, since it wouldn't surprise m=
e
> if Jan didn't test the case of using nobarrier with a storage array
> with battery backup (I certainly didn't, since I don't have easy
> access to such fancy toys :-).

Hm. At boot, I see this for both volumes on the Areca controller:

[    0.855376] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    0.855465] sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA

So it looks to me like FUA changes themselves could have little effect.

(btw, the controller cost only about =C2=A3150... if it was particularl=
y
fancy I certainly couldn't have afforded it.)

>> It also appears impossible for me to reliably shut my system down,
>> though a 60s timeout after lazy umount and before reboot is likely t=
o
>> work in all but the most pathological of cases (where a downed NFS
>> server comes up at just the wrong instant): it is clear that the
>> previous 5s timeout eventually became insufficient simply because of=
 the
>> amount of time it can take to do a umount on today's larger filesyst=
ems.
>
> Something that you might want to consider trying is after you kill al=
l
> of the processes, remount all of the local disk file systems
> read-only, then kick off the unmount of the NFS file systems (just to
> be nice to the NFS servers, so they are notified of the unmount), and

Actually I umount NFS first of all, because if I kill the processes
first, this causes trouble with the NFS unmounts, particularly if I'm
doing self-mounting (which I do sometimes, though not at the moment).

I will certainly try a readonly remount instead.

> force a flush on an unmount or remount r/o, regardless of whether
> nobarrier is specified, just to make sure everything is written out
> before the poweroff, battery backup or no.)

I'm rather surprised that doesn't happen anyway. I always thought it
did.

--=20
NULL && (void)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
