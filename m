From: "Amir G." <amir73il@users.sourceforge.net>
Subject: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Wed, 8 Jun 2011 21:26:11 +0300
Message-ID: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1FHS0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 14:26:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 7:19 PM, Mike Snitzer <snitzer@redhat.com> wrote=
:
> On Wed, Jun 8, 2011 at 11:59 AM, Amir G. <amir73il@users.sourceforge.=
net> wrote:
>> On Wed, Jun 8, 2011 at 6:38 PM, Lukas Czerner <lczerner@redhat.com> =
wrote:
>>> Amir said:
>
>>>> The question of whether the world needs ext4 snapshots is
>>>> perfectly valid, but going back to the food analogy, I think it's
>>>> a case of "the proof of the pudding is in the eating".
>>>> I have no doubt that if ext4 snapshots are merged, many people wil=
l use it.
>>>
>>> Well, I would like to have your confidence. Why do you think so ? T=
hey
>>> will use it for what ? Doing backups ? We can do this easily with L=
VM
>>> without any risk of compromising existing filesystem at all. On des=
ktop
>>
>> LVM snapshots are not meant to be long lived snapshots.
>> As temporary snapshots they are fine, but with ext4 snapshots
>> you can easily retain monthly/weekly snapshots without the
>> need to allocate the space for it in advance and without the
>> 'vanish' quality of LVM snapshots.
>
> In that old sf.net wiki you say:
> Why use Next3 snapshots and not LVM snapshots?
> * Performance: only small overhead to write performance with snapshot=
s
>
> Fair claim against current LVM snapshot (but not multisnap).
>
> In this thread you're being very terse on the performance hit you
> assert multisnap has that ext4 snapshots does not. =A0Can you please =
be
> more specific?
>
> In your most recent post it seems you're focusing on "LVM snapshots"
> and attributing the deficiencies of old-style LVM snapshots
> (non-shared exception store causing N-way copy-out) to dm-multisnap?
>
> Again, nobody will dispute that the existing dm-snapshot target has
> poor performance that requires snapshots be short-lived. =A0But
> multisnap does _not_ suffer from those performance problems.
>
> Mike
>

Hi Mike,

I am glad that you joined the debate and I am going to start a fresh
thread for that occasion, to give your question the proper attention.

In my old next3.sf.net wiki, which I do update from time to time,
I listed 4 advantages of Ext4 (then next3) snapshots over LVM:
* Performance: only small overhead to write performance with snapshots
* Scalability: no extra overhead per snapshot
* Maintenance: no need to pre-allocate disk space for snapshots
* Persistence: snapshots don't vanish when disk is full

As far as I know, the only thing that has changed from dm-snap
to dm-multisnap is the Scalability.

Did you resolve the Maintenance and Persistence issues?

With Regards to Performance, Ext4 snapshots are inherently different
then LVM snapshots and have near zero overhead to write performance
as the following benchmark, which I presented on LSF, demonstrates:
http://global.phoronix-test-suite.com/index.php?k=3Dprofile&u=3Damir73i=
l-4632-11284-26560

There are several reasons for the near zero overhead:

1. Metadata buffers are always in cache when performing COW,
so there is no extra read I/O and write I/O of the copied pages is hand=
led
by the journal (when flushing the snapshot file dirty pages).

2. Data blocks are never copied
The move-on-write technique is used to re-allocate data blocks on rewri=
te
instead of copying them.
This is not something that can be done when the snapshot is stored on
external storage, but it can done when the snapshot file lives in the f=
s.

3. New (=3D after last snapshot take) allocated blocks are never copied
nor reallocated on rewrite.
Ext4 snapshots uses the fs block bitmap, to know which blocks were allo=
cated
at the time the last snapshot was taken, so new blocks are just out of =
the game.
=46or example, in the workload of a fresh kernel build and daily snapsh=
ots,
the creation and deletion of temp files causes no extra I/O overhead wh=
atsoever.

So, yes, I know. I need to run a benchmark of Ext4 snapshots vs. LVM mu=
ltisnap
and post the results. When I'll get around to it I'll do it.
But I really don't think that performance is how the 2 solutions
should be compared.

The way I see it, LVM snapshots are a complementary solution and they
have several advantages over Ext4 snapshots, like:
* Work with any FS
* Writable snapshots and snapshots of snapshots
* Merge a snapshot back to the main vol

We actually have one Google summer of code project that is going to exp=
ort
an Ext4 snapshot to an LVM snapshot, in order to implement the "revert
to snapshot"
functionality, which Ext4 snapshots is lacking.

I'll be happy to answer more question regarding Ext4 snapshots.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
