From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Wed, 8 Jun 2011 12:09:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com> <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1FHKJd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 06:09:33 -0400
In-Reply-To: <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 7 Jun 2011, Amir G. wrote:

> On Tue, Jun 7, 2011 at 6:56 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > Hi Amir,
> >
> > thanks very much for the resend. I'll take a look at the whole patch
> > series, but first I want to bring up one important thing.
> >
> > While this being a huge feature for ext4 (regardless on how
> > intrusive it is for the usual code paths) and while we already have
> > patches in the list with people interesting in looking into them, you
> > should clearly clarify what is the gain of it, what is the use case (and
> > I know you have one), and why it is better than other approaches. You
> > know, advertise it a bit in the marketing way :).
> 
> Hi Lukas,
> 
> Thank you for pointing out the marketing aspect.
> 
> I must admit that my user-case rather speaks for itself.
> CTERA develops a NAS device which is specialized for
> backing up local networks and snapshots gives the NAS a time
> dimension without paying for it in disk space and performance.
> 
> The reason for not going with btrfs 3 years ago is clear.
> So why not go with it now instead of moving forward to
> ext4 with snapshots?
> Part of the answer lies in the possibility to run fsck -x,
> which gets rid of the snapshots in the case of fs corruption
> and gets you back to good old stable and consistent ext4.

But that is not even a real reason, is it ? When you need snapshots,
well, then you just need it and do no want to get rid of it. When fs
corruption appears, then it's bad in any case and the fsck should be
able to more or less fix it.

So you're saying that when corruption appears, then you *have to* blast
all snapshots ? I am not sure how btrfs is going to deal with it, but it
does seem like an advantage at all, why are you presenting it as such ?

> 
> >
> > There is some confusion among developers on what actually are benefits
> > of ext4 snapshots in comparison to btrfs, or in comparison to the new
> > dm_multisnap code. I know that you have done quite a lot of testing to
> > assure that it does not actually change old ext4 behavior when snapshot
> > disabled, and that it works well when enabled, but have you done any
> > performance related benchmarks ? Do you have any expectations on how it
> > should behave in different work loads ?
> >
> > It would be great to see and be able to confirm that ext4 snapshots are
> > really a win, not only on the feature side, but on the performance side
> > as well. I know that there are people out there still undecided or
> > having a strange feeling about your snapshot work. But who can blame
> > them, when we have not seen any hard data on this matter ?
> 
> Ehm.. I did present this benchmark on LSF:
> http://global.phoronix-test-suite.com/index.php?k=profile&u=amir73il-4632-11284-26560
> 
> unless you snoozed ;-)
> it shows performance vs. ext4 w/o snapshots and with snapshots
> and while taking snapshots.

I believe that you just missed the fact that not everyone has attended LSF
and your lightning talk, but that's ok.

It seems to me that random writes are usually faster with you snapshot
code regardless whether you use snapshots or not. Is that because of
non snapshot related changes you've made ?

Also random reads seems to be slower with snapshots, is suspect that
this is because of read through, so the reason for the slowdown that it
was CPU bound ? I do not see any CPU utilization data.

The postmark results seems quite odd, it is actually a lot faster with
one snapshot and a lot slower with multiple snapshots, do you have an
idea what is going on ?

> I did not compare with btrfs, but I bet there are ext4 vs. btrfs
> benchmarks out there.
> dm-multisnap is better than dm-snap only when it comes to overhead
> per snapshot. it still copies every written block, which is far from
> being the case in ext4 snapshots.

Nevertheless, I still have not seen any comparison with other
snapshotting possibilities we have. Note that ext4 to btrfs comparison
is not enough, because we do not know what is the difference between
the difference of ext4 with/without snapshots and btrfs with/without
snapshots. The reason for this is that btrfs performance is very likely
to scale up, but ext4 is pretty much done in that matter and I do not
expect any huge performance leaps in the future.

Also, rejecting dm-multisnap based on this statement is not enough, show
us some numbers.

I believe that it is not very convenient for you, because this feature
support your business case and you do not necessarily want to find out
that there might be a better way, especially after the work you have
done already.

So it might be unpleasant for you that people ask questions and delaying
the inclusion of ext4 snapshots. But what you see as obstacles people
are throwing at you is really just caution, especially when it comes to
ext4 which is seen as a simple, stable, reliable and predictable linux
filesystem, but I bet you understand.

And one last note, I also think that the snapshot format change in the
future, when we'll have snpashots with 64bit feature compatible seems
just wrong to me. Adding some features or changing the implementation a
bit is ok, but format change is different. When the code is upstream and
stable it is just wrong.

Thanks!
-Lukas

> 
> >
> > So I, for myself, and I believe there are others, would like to see some
> > benchmark numbers and comparison (both, features and performance) with at
> > least new dm-multisnap code and probably btrfs and plain ext4 as well.
> >
> > Thanks!
> > -Lukas
> >
