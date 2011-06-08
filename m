From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Wed, 8 Jun 2011 17:04:54 +0300
Message-ID: <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1FHOE4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 10:04:56 -0400
In-Reply-To: <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 1:09 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Tue, 7 Jun 2011, Amir G. wrote:
>
>> On Tue, Jun 7, 2011 at 6:56 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> > Hi Amir,
>> >
>> > thanks very much for the resend. I'll take a look at the whole patch
>> > series, but first I want to bring up one important thing.
>> >
>> > While this being a huge feature for ext4 (regardless on how
>> > intrusive it is for the usual code paths) and while we already have
>> > patches in the list with people interesting in looking into them, you
>> > should clearly clarify what is the gain of it, what is the use case (and
>> > I know you have one), and why it is better than other approaches. You
>> > know, advertise it a bit in the marketing way :).
>>
>> Hi Lukas,
>>
>> Thank you for pointing out the marketing aspect.
>>
>> I must admit that my user-case rather speaks for itself.
>> CTERA develops a NAS device which is specialized for
>> backing up local networks and snapshots gives the NAS a time
>> dimension without paying for it in disk space and performance.
>>
>> The reason for not going with btrfs 3 years ago is clear.
>> So why not go with it now instead of moving forward to
>> ext4 with snapshots?
>> Part of the answer lies in the possibility to run fsck -x,
>> which gets rid of the snapshots in the case of fs corruption
>> and gets you back to good old stable and consistent ext4.
>
> But that is not even a real reason, is it ? When you need snapshots,
> well, then you just need it and do no want to get rid of it. When fs
> corruption appears, then it's bad in any case and the fsck should be
> able to more or less fix it.
>
> So you're saying that when corruption appears, then you *have to* blast
> all snapshots ? I am not sure how btrfs is going to deal with it, but it
> does seem like an advantage at all, why are you presenting it as such ?
>

Hi Lukas,

First of all, thank you for being strict with me.
I admit to having lousy marketing skills...

The market I am targeting are the sys admins who
are very cautious about their 'data' and are reluctant
therefor to migrate from ext3 to ext4, not to speak of
btrfs.

To this market I say, you can have snapshots of your
'data' on ext4 without risking the proven stability of ext4.
The snapshots of the 'data' are not guarantied to be as
stable (being a new feature), but because the snapshots
are second to 'data' in ext4 snapshots, corrupted snapshots
will not risk the 'data'.

During 1 year of next3 in production systems, we found bugs.
But none of the bugs corrupted 'data'. All of the bugs which
caused file system to contain errors, the errors were restricted
to snapshot files and in those worst cases, we could always
go to emergency plan B (plan A being fsck -p) and run fsck -x
which always solved the problem.

The customer was always consulted before resorting to 'plan B'
and was given the chance to copy out 'data' from the snapshots
(it was always possible) before we discard them.

Needless to say, the said bugs were fixed and ext4 snapshots
will enjoy the stability of next3 and the 'fail safe' nature of the
solution, which was proven several times on the field.


>>
>> >
>> > There is some confusion among developers on what actually are benefits
>> > of ext4 snapshots in comparison to btrfs, or in comparison to the new
>> > dm_multisnap code. I know that you have done quite a lot of testing to
>> > assure that it does not actually change old ext4 behavior when snapshot
>> > disabled, and that it works well when enabled, but have you done any
>> > performance related benchmarks ? Do you have any expectations on how it
>> > should behave in different work loads ?
>> >
>> > It would be great to see and be able to confirm that ext4 snapshots are
>> > really a win, not only on the feature side, but on the performance side
>> > as well. I know that there are people out there still undecided or
>> > having a strange feeling about your snapshot work. But who can blame
>> > them, when we have not seen any hard data on this matter ?
>>
>> Ehm.. I did present this benchmark on LSF:
>> http://global.phoronix-test-suite.com/index.php?k=profile&u=amir73il-4632-11284-26560
>>
>> unless you snoozed ;-)
>> it shows performance vs. ext4 w/o snapshots and with snapshots
>> and while taking snapshots.
>
> I believe that you just missed the fact that not everyone has attended LSF
> and your lightning talk, but that's ok.

That's not really OK. I should have posted the results
and analysis on my wiki (the results are there).

>
> It seems to me that random writes are usually faster with you snapshot
> code regardless whether you use snapshots or not. Is that because of
> non snapshot related changes you've made ?

Not that I know of.
I can explain why random write onesnap is faster than nosnap
and why 1snappermin is faster than onesnap, but I am not
sure about nosnap vs. plain ext4.

>
> Also random reads seems to be slower with snapshots, is suspect that
> this is because of read through, so the reason for the slowdown that it
> was CPU bound ? I do not see any CPU utilization data.
>

Only the 1snappermin is slower.
I suspect it has to do with the fs freezes, but I admin I have not
looked into it.

> The postmark results seems quite odd, it is actually a lot faster with
> one snapshot and a lot slower with multiple snapshots, do you have an
> idea what is going on ?
>

The name onesnap is misleading. It should have been
existingsnaps.
The important factor is whether or not snapshots are taken during the test.
In the 1snappermin case, postmark is the only test that exposes the
weak spot of ext4 snapshots performance - deletes/truncates.
create file+delete file with existing snapshots has no overhead (no COW).
create file+take snapshot+delete file has the overhead of moving the
deleted blocks to snapshot.
With regards to speed up of onesnap, postmark is randomizing the file
creates/write so it may be a similar effect to random write.
I did not investigate this.

>> I did not compare with btrfs, but I bet there are ext4 vs. btrfs
>> benchmarks out there.
>> dm-multisnap is better than dm-snap only when it comes to overhead
>> per snapshot. it still copies every written block, which is far from
>> being the case in ext4 snapshots.
>
> Nevertheless, I still have not seen any comparison with other
> snapshotting possibilities we have. Note that ext4 to btrfs comparison
> is not enough, because we do not know what is the difference between
> the difference of ext4 with/without snapshots and btrfs with/without
> snapshots. The reason for this is that btrfs performance is very likely
> to scale up, but ext4 is pretty much done in that matter and I do not
> expect any huge performance leaps in the future.
>
> Also, rejecting dm-multisnap based on this statement is not enough, show
> us some numbers.

Well, if you come to understand the difference between fs level an dm
level snapshots, you will see why i am rejecting dm-multisnap
(performance wise only!).

Anyway #1: I have already answered this questions 2 years ago and I
think the answers are still valid both for LVM and btrfs:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=FAQ#Why_use_Next3_snapshots_and_not_LVM_snapshots.3F

Anyway #2: I need to give you some numbers ;-)

>
> I believe that it is not very convenient for you, because this feature
> support your business case and you do not necessarily want to find out
> that there might be a better way, especially after the work you have
> done already.

Your analysis of my motives is correct :-)
The use of the term 'better way' I reject.
I think that ext4/btrfs/LVM snapshots are apples and oranges and hamburgers.
The question of whether the world needs ext4 snapshots is
perfectly valid, but going back to the food analogy, I think it's
a case of "the proof of the pudding is in the eating".
I have no doubt that if ext4 snapshots are merged, many people will use it.
And I think that is a good enough (if not the best)
reason for inclusion.


>
> So it might be unpleasant for you that people ask questions and delaying
> the inclusion of ext4 snapshots. But what you see as obstacles people
> are throwing at you is really just caution, especially when it comes to
> ext4 which is seen as a simple, stable, reliable and predictable linux
> filesystem, but I bet you understand.
>

Yes, I understand. As evidence, I posted the "core patches"
to get them reviewed for "safely" and "stability" rather than
"functionality". (and that didn't work out well, but I understand that as well).

> And one last note, I also think that the snapshot format change in the
> future, when we'll have snpashots with 64bit feature compatible seems
> just wrong to me. Adding some features or changing the implementation a
> bit is ok, but format change is different. When the code is upstream and
> stable it is just wrong.

What can I say, I understand why it looks bad, but is 64bit code
upstream and stable? Hell no! e2fsprogs 64bit is not out yet!
There is no reason to call it 'format change'.
It's going to be a new format used only for 64bit fs, which are not
even out there yet. And when they are finally out there, they won't
have
snapshots until the new format is implemented.

And more important, say I do implement a new 48bit logical
offsets file format, so my employer can provide snapshots on
>16TB volumes in future releases.
I will not recommend my employer to use this format on <16TB volumes,
because there is nothing wrong with staying with the simple and well
tested indirect mapped snapshot format in future releases.

Thanks for your time and patience,
Amir.
