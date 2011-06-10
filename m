From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Fri, 10 Jun 2011 17:15:37 +0300
Message-ID: <BANLkTi=zjU3-FV3AVpYsknzKFgaS7byb_Q@mail.gmail.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
	<BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
	<alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
	<20110610101142.GA10144@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Joe Thornber <thornber@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110610101142.GA10144@ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 10, 2011 at 1:11 PM, Joe Thornber <thornber@redhat.com> wro=
te:
> On Fri, Jun 10, 2011 at 11:01:41AM +0200, Lukas Czerner wrote:
>> On Fri, 10 Jun 2011, Amir G. wrote:
>>
>> > CC'ing lvm-devel and fsdevel
>> >
>> >
>> > On Wed, Jun 8, 2011 at 9:26 PM, Amir G. <amir73il@users.sourceforg=
e.net> wrote:
>> > For the sake of letting everyone understand the differences and tr=
ade
>> > offs between
>> > LVM and ext4 snapshots, so ext4 snapshots can get a fair trial, I =
need
>> > to ask you
>> > some questions about the implementation, which I could not figure =
out by myself
>> > from reading the documents.
>
> First up let me say that I'm not intending to support writeable
> _external_ origins with multisnap. =A0This will come as a suprise to
> many people, but I don't think we can resolve the dual requirements t=
o
> efficiently update many, many snapshots when a write occurs _and_ mak=
e
> those snapshots quick to delete (when you're encouraging people to
> take lots of snapshots performance of delete becomes a real issue).
>

OK. that is an interesting point for people to understand.
There is a distinct trade off at hand.

LVM multisnap gives you lots of feature and can be used with
any filesystem.
The cost you are paying for all the wonderful features it provides is
a fragmented origin, which we both agree, is likely to have performance
costs as the filesystem ages.

Ext4 snapshots, on the other hand, is very limited in features
(i.e. only readonly snapshots of the origin), but the origin's layout o=
n-disk
remains un-fragmented and optimized for spinning media and RAID
arrays underlying storage.

Ext4 snapshots also causes fragmentation of files in random write
workloads, but this is a problem that can and is being fixed.

> One benefit of this decision is that there is no copying from an
> external origin into the multisnap data store.
>
> For internal snapshots (a snapshot of a thin provisioned volume, or
> recursive snapshot), copy-on-write does occur. =A0If you keep the
> snapshot block size small, however, you find that this copying can
> often be elided since the new data completely overwrites the old.
>
> This avoidance of copying, and the use of FUA/FLUSH to schedule
> commits means that performance is much better than the old snaps. =A0=
It
> wont be as fast as ext4 snapshots, it can't be, we don't know what th=
e
> bios contain, unlike ext4. =A0But I think the performance will be goo=
d
> enough that many people will be happy with this more general solution
> rather than committing to a particular file system. =A0There will be =
use
> cases where snapshotting at the fs level is the only option.
>

I have to agree with you. I do not think that the performance factor
is going to be a show stopper for most people.
I do think that LVM performance will be good enough
and that many people will be happy with the more general solution.
Especially those who can afford an SSD in their system.

The question is, are there enough people in the 'real world', with
enough varying use cases, so that many will also find ext4 snapshots fe=
atures
good enough and will want to enjoy better and consistent read/write per=
formance
to the origin, which does not degrade as the filesystem ages.

Clearly, we will need to come up with some 'real world' benchmarks, bef=
ore
we can provide an intelligent answer to that question.

>> > 1. Crash resistance
>> > How is multisnap handling system crashes?
>> > Ext4 snapshots are journaled along with data, so they are fully
>> > resistant to crashes.
>> > Do you need to keep origin target writes pending in batches and is=
sue FUA/flush
>> > request for the metadata and data store devices?
>
> FUA/flush allows us to treat multisnap devices as if they are devices
> with a write cache. =A0When a FUA/FLUSH bio comes in we ensure we com=
mit
> metadata before allowing the bio to continue. =A0A crash will lose da=
ta
> that is in the write cache, same as any real block device with a writ=
e
> cache.
>

Now, here I am confused.
Reducing the problem to write cache enabled device sounds valid,
but I am not yet convinced it is enough.
In ext4 snapshots I had to deal with 'internal ordering' between I/O
of origin data and snapshot metadata and data.
That means that every single I/O to origin, which overwrites shared dat=
a,
must hit the media *after* the original data has been copied to snapsho=
t
and the snapshot metadata and data are secure on media.
In ext4 this is done with the help of JBD2, which anyway holds back met=
adata
writes until commit.
It could be that this problem is only relevant to _extenal_ origin, whi=
ch
are not supported for multisnap, but frankly, as I said, I am too confu=
sed
to figure out if there is yet an ordering problem for _internal_ origin=
 or not.

>> > 2. Performance
>> > In the presentation from LinuxTag, there are 2 "meaningless benchm=
arks".
>> > I suppose they are meaningless because the metadata is linear mapp=
ing
>> > and therefor all disk writes and read are sequential.
>> > Do you have any "real world" benchmarks?
>
> Not that I'm happy with. =A0For me 'real world' means a realistic use=
 of
> snapshots. =A0We've not had this ability to create lots of snapshots
> before in Linux, so I'm not sure how people are going to use it. =A0I=
'll
> get round to writing some benchmarks for certain scenarios eventually
> (eg. incremental backups), but atm there are more pressing issues.
>
> I mainly called those benchmarks meaningless because they didn't
> address how fragmented the volumes become over time. =A0This
> fragmentation is a function of io pattern, and the shape of the
> snapshot tree. =A0In the same way I think filesystem benchmarks that
> write lots of files to a freshly formatted volume are also pretty
> meaningless. =A0What most people are interested in is how the system
> will be performing after they've used it for six months, not the firs=
t
> five minutes.
>
>> > I am guessing that without the filesystem level knowledge in the t=
hin
>> > provisioned target,
>> > files and filesystem metadata are not really laid out on the hard
>> > drive as the filesystem
>> > designer intended.
>> > Wouldn't that be causing a large seek overhead on spinning media?
>
> You're absolutely right.
>
>> > 3. ENOSPC
>> > Ext4 snapshots will get into readonly mode on unexpected ENOSPC si=
tuation.
>> > That is not perfect and the best practice is to avoid getting to
>> > ENOSPC situation.
>> > But most application do know how to deal with ENOSPC and EROFS gra=
cefully.
>> > Do you have any "real life" experience of how applications deal wi=
th
>> > blocking the
>> > write request in ENOSPC situation?
>
> If you run out of space userland needs to extend the data volume. =A0=
the
> multisnap-pool target notifies userland (ie. dmeventd) before it
> actually runs out. =A0If userland hasn't resized the volume before it
> runs out of space then the ios will be paused. =A0This pausing is rea=
lly
> no different from suspending a dm device, something LVM has been doin=
g
> for 10 years. =A0So yes, we have experience of pausing io under
> applications, and the 'notify userland' mechanism is already proven.
>
>> > Or what is the outcome if someone presses the reset button because=
 of an
>> > unexplained (to him) system halt?
>
> See my answer above on crash resistance.
>
>> > 4. Cache size
>> > At the time, I examined using ZFS on an embedded system with 512MB=
 RAM.
>> > I wasn't able to find any official requirements, but there were
>> > several reports around
>> > the net saying that running ZFS with less that 1GB RAM is a perfor=
mance killer.
>> > Do you have any information about recommended cache sizes to preve=
nt
>> > the metadata store from being a performance bottleneck?
>
> The ideal cache size depends on your io patterns. =A0It also depends =
on
> the data block size you've chosen. =A0The cache is divided into 4k
> blocks, and each block holds ~256 mapping entries.
>
> Unlike ZFS our metadata is very simple.
>
> Those little micro benchmarks (dd and bonnie++) running on a little 4=
G
> data volume perform nicely with only a 64k cache. =A0So in the worst
> case I was envisaging a few meg for the cache, rather than a few
> hundred meg.
>
> - Joe
>

Thanks for your elaborate answers!
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
