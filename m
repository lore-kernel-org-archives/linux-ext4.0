From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Fri, 10 Jun 2011 10:45:47 +0300
Message-ID: <BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51088 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1FJHpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 03:45:49 -0400
In-Reply-To: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 9:26 PM, Amir G. <amir73il@users.sourceforge.net=
> wrote:
> On Wed, Jun 8, 2011 at 7:19 PM, Mike Snitzer <snitzer@redhat.com> wro=
te:
>> On Wed, Jun 8, 2011 at 11:59 AM, Amir G. <amir73il@users.sourceforge=
=2Enet> wrote:
>>> On Wed, Jun 8, 2011 at 6:38 PM, Lukas Czerner <lczerner@redhat.com>=
 wrote:
>>>> Amir said:
>>
>>>>> The question of whether the world needs ext4 snapshots is
>>>>> perfectly valid, but going back to the food analogy, I think it's
>>>>> a case of "the proof of the pudding is in the eating".
>>>>> I have no doubt that if ext4 snapshots are merged, many people wi=
ll use it.
>>>>
>>>> Well, I would like to have your confidence. Why do you think so ? =
They
>>>> will use it for what ? Doing backups ? We can do this easily with =
LVM
>>>> without any risk of compromising existing filesystem at all. On de=
sktop
>>>
>>> LVM snapshots are not meant to be long lived snapshots.
>>> As temporary snapshots they are fine, but with ext4 snapshots
>>> you can easily retain monthly/weekly snapshots without the
>>> need to allocate the space for it in advance and without the
>>> 'vanish' quality of LVM snapshots.
>>
>> In that old sf.net wiki you say:
>> Why use Next3 snapshots and not LVM snapshots?
>> * Performance: only small overhead to write performance with snapsho=
ts
>>
>> Fair claim against current LVM snapshot (but not multisnap).
>>
>> In this thread you're being very terse on the performance hit you
>> assert multisnap has that ext4 snapshots does not. =A0Can you please=
 be
>> more specific?
>>
>> In your most recent post it seems you're focusing on "LVM snapshots"
>> and attributing the deficiencies of old-style LVM snapshots
>> (non-shared exception store causing N-way copy-out) to dm-multisnap?
>>
>> Again, nobody will dispute that the existing dm-snapshot target has
>> poor performance that requires snapshots be short-lived. =A0But
>> multisnap does _not_ suffer from those performance problems.
>>
>> Mike
>>
>
> Hi Mike,
>
> I am glad that you joined the debate and I am going to start a fresh
> thread for that occasion, to give your question the proper attention.
>
> In my old next3.sf.net wiki, which I do update from time to time,
> I listed 4 advantages of Ext4 (then next3) snapshots over LVM:
> * Performance: only small overhead to write performance with snapshot=
s
> * Scalability: no extra overhead per snapshot
> * Maintenance: no need to pre-allocate disk space for snapshots
> * Persistence: snapshots don't vanish when disk is full
>
> As far as I know, the only thing that has changed from dm-snap
> to dm-multisnap is the Scalability.
>
> Did you resolve the Maintenance and Persistence issues?
>
> With Regards to Performance, Ext4 snapshots are inherently different
> then LVM snapshots and have near zero overhead to write performance
> as the following benchmark, which I presented on LSF, demonstrates:
> http://global.phoronix-test-suite.com/index.php?k=3Dprofile&u=3Damir7=
3il-4632-11284-26560
>
> There are several reasons for the near zero overhead:
>
> 1. Metadata buffers are always in cache when performing COW,
> so there is no extra read I/O and write I/O of the copied pages is ha=
ndled
> by the journal (when flushing the snapshot file dirty pages).
>
> 2. Data blocks are never copied
> The move-on-write technique is used to re-allocate data blocks on rew=
rite
> instead of copying them.
> This is not something that can be done when the snapshot is stored on
> external storage, but it can done when the snapshot file lives in the=
 fs.
>
> 3. New (=3D after last snapshot take) allocated blocks are never copi=
ed
> nor reallocated on rewrite.
> Ext4 snapshots uses the fs block bitmap, to know which blocks were al=
located
> at the time the last snapshot was taken, so new blocks are just out o=
f the game.
> For example, in the workload of a fresh kernel build and daily snapsh=
ots,
> the creation and deletion of temp files causes no extra I/O overhead =
whatsoever.
>
> So, yes, I know. I need to run a benchmark of Ext4 snapshots vs. LVM =
multisnap
> and post the results. When I'll get around to it I'll do it.
> But I really don't think that performance is how the 2 solutions
> should be compared.
>
> The way I see it, LVM snapshots are a complementary solution and they
> have several advantages over Ext4 snapshots, like:
> * Work with any FS
> * Writable snapshots and snapshots of snapshots
> * Merge a snapshot back to the main vol
>
> We actually have one Google summer of code project that is going to e=
xport
> an Ext4 snapshot to an LVM snapshot, in order to implement the "rever=
t
> to snapshot"
> functionality, which Ext4 snapshots is lacking.
>
> I'll be happy to answer more question regarding Ext4 snapshots.
>
> Thanks,
> Amir.
>


Hi Mike,

In the beginning of this thread I wrote that "competition is good
because it makes us modest",
so now I have to live up to this standard and apologize for not
learning the new LVM
implementation properly before passing judgment.

To my defense, I could not find any design papers and benchmarks on mul=
tisnap
until Christoph had pointed me to some (and was too lazy to read the co=
de...)

Anyway, it was never my intention to bad mouth LVM. I think LVM is a ve=
ry useful
tool and the new multisnap and thinp targets look very promising.

=46or the sake of letting everyone understand the differences and trade
offs between
LVM and ext4 snapshots, so ext4 snapshots can get a fair trial, I need
to ask you
some questions about the implementation, which I could not figure out b=
y myself
from reading the documents.

1. Crash resistance
How is multisnap handling system crashes?
Ext4 snapshots are journaled along with data, so they are fully
resistant to crashes.
Do you need to keep origin target writes pending in batches and issue F=
UA/flush
request for the metadata and data store devices?

2. Performance
In the presentation from LinuxTag, there are 2 "meaningless benchmarks"=
=2E
I suppose they are meaningless because the metadata is linear mapping
and therefor all disk writes and read are sequential.
Do you have any "real world" benchmarks?
I am guessing that without the filesystem level knowledge in the thin
provisioned target,
files and filesystem metadata are not really laid out on the hard
drive as the filesystem
designer intended.
Wouldn't that be causing a large seek overhead on spinning media?

3. ENOSPC
Ext4 snapshots will get into readonly mode on unexpected ENOSPC situati=
on.
That is not perfect and the best practice is to avoid getting to
ENOSPC situation.
But most application do know how to deal with ENOSPC and EROFS graceful=
ly.
Do you have any "real life" experience of how applications deal with
blocking the
write request in ENOSPC situation?
Or what is the outcome if someone presses the reset button because of a=
n
unexplained (to him) system halt?

4. Cache size
At the time, I examined using ZFS on an embedded system with 512MB RAM.
I wasn't able to find any official requirements, but there were
several reports around
the net saying that running ZFS with less that 1GB RAM is a performance=
 killer.
Do you have any information about recommended cache sizes to prevent
the metadata store from being a performance bottleneck?

Thank you!
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
