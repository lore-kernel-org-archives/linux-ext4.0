From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 30 Mar 2011 06:16:45 +0200
Message-ID: <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
	<20110204002043.GA15658@noexit>
	<AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
	<20110330003429.GA32669@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Joel Becker <jlbec@evilplan.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110330003429.GA32669@noexit>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 30, 2011 at 2:34 AM, Joel Becker <jlbec@evilplan.org> wrote=
:
> On Wed, Mar 23, 2011 at 10:19:38PM +0200, Amir Goldstein wrote:
>> On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> wro=
te:
>> > On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
>> > =A0 =A0 =A0 =A0I've already got a design for a front-end snapshot =
program that
>> > implements a policy on top this generic behavior. =A0This design w=
ould
>> > cover both first-class and hidden style snapshots, because it assu=
me
>> > snapshots are in a distinct namespace. =A0I haven't gotten around =
to
>> > implementing it yet, but btrfs and other snapshottable filesystems=
 were
>> > part of the design goal.
>>
>> Any chance of getting a copy of that design of yours, to get a head =
start
>> for LSF?
>
> =A0 =A0 =A0 =A0Yeah, I owe it to you. =A0It wasn't a written-down thi=
ng, it was a
> hammered-out-in-our-heads thing among some ocfs2 developers. =A0I'm g=
oing
> to braindump here to get us going. =A0First, I'll speak to your point=
s.
>
>> Here are some other generic snapshot related topics we may want to d=
iscuss:
>>
>> 1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggested =
by Chris.
>
> =A0 =A0 =A0 =A0I'm unsure where these fit, perhaps because I missed t=
he
> discussion between Chris and you. =A0ocfs2 has the inode flag
> OCFS2_REFCOUNTED_FL to signify a refcount tree is attached to the ino=
de.
> This is ocfs2's structure for maintaining extent reference counts. =A0=
Is
> your COW_FL the same? =A0Or is it a permission flag? =A0NOCOW_FL soun=
ds
> like: "Set this flag on the inode and it will prevent CoW."

I don't have a use for COW_FL, since my snapshots are volume level snap=
shots.
I intend to use NOCOW_FL to mark an inode as an "island" of NOCOW
blocks in the volume.
Maybe Chris or Josef can elaborate of the flags intended use in btrfs.

>
>> 2. How to deal with mmap write to COW file, when you get ENOSPC.
>
> =A0 =A0 =A0 =A0We just fail the write with VM_FAULT_SIGBUS like mmap =
write to a
> hole. =A0It's what happens for most other CoW filesystems today. =A0I=
f
> you're using CoW, you should be aware of what to expect.
>

"you", meaning a CoW fs developer? a CoW fs administrator? or an applic=
ation
developer, who has no idea what fs the application will be on?
I know it is easy for us to say "there is no solution", but I have
actually implemented
a block reservation technique that may be useful in this case...
it's hammered-out-in-my-head, so let's save me the brain dump and I'll =
tell
you about it in person...


>> 3. Adding buffer_remap() flag for buffered I/O code, meaning, there =
is
>> an existing mapping to initialize a page on partial write, but still=
 need
>> to call get_block() to get a (possibly) new mapping.
>
> =A0 =A0 =A0 =A0Since ocfs2 doesn't allocate in get_block(), this does=
n't affect
> us. =A0We notice the refcounted extent in write_begin() and CoW it ri=
ght
> there. =A0Same place we clean up unwritten extents.
>

Yes, I was going to write a specialized block_write_begin() for CoW,
but I like to use existing generic code when possible and block_write_b=
egin()
is only a few lines of code short of what I need, so maybe we can all u=
se it?


> --snip--
>
> =A0 =A0 =A0 =A0Now, about my snapshot thoughts as promised. =A0My und=
erstanding
> of the snapshots you have implemented in ext4 is that they are like s=
ome
> SAN snapshots; they are hidden objects not visible unless you use
> special access. =A0They are particular to a given inode and are child=
ren
> of that inode. =A0What happens when you remove the visible inode? =A0=
Do the
> snapshots disappear? =A0Do you have limitations on how many shapshots=
 a
> particular inode can have? =A0These questions plagued us when we orig=
inal
> set out to design inode snapshots for ocfs2.

ext4 snapshots are volume level (readonly) snapshots.
the snapshot inodes are both the "place-holder" of private snapshot blo=
cks
and the (loopdev) mount point to access the volume snapshot.
This is why I wondered if inode level snapshots and volume/subvolume
level snapshots can share the same API.
BTW, does btrfs have inode level snapshots as well?

> =A0 =A0 =A0 =A0Once we settled on a mechanism for CoW among ocfs2 ino=
des, we
> quickly decided that a snapshot should be visible in the namespace.
> This gave rise to the reflink(2) call, though that name is deprecated=
 in
> favor of fastcopy(2). =A0Currently our API is OCFS2_IOC_REFLINK (see,
> legacy!), but we eventually want to get the system call upstream. =A0=
In
> ocfs2-land, we decided to keep policy out of the kernel.
> OCFS2_IOC_REFLINK creates a new inode that shares all the extents of =
the
> source in CoW fashion, but once it returns, that new inode is a peer =
of
> the source. =A0There is no parent->child relationship.
> =A0 =A0 =A0 =A0Thus, for ocfs2 (and forgive the legacy names, the bin=
ary hasn't
> changed yet), a "snapshot" is just:
>
> =A0 =A0snapshot: reflink source target.snap && chmod 0444 target.snap
>
> You can add "chattr +i target.snap" in there if you like.
> =A0 =A0 =A0 =A0Since there is no "snapshot namespace" stuff for ocfs2=
 in the
> kernel, it was our intention to propose a snapshot(8) binary that wor=
ks
> like mkfs/fsck; snapshot(8) just calls snapshot.<fstype>(8). =A0Our
> plan was to place snapshot policy in snapshot.ocfs2(8). =A0This
> implementation would handle managing the <mountpoint>/.snapshot/...
> namespace behind the user:
>
> =A0 =A0? cd /mnt/ocfs2
> =A0 =A0? snapshot file1 =A0# Creates /mnt/ocfs2/.snapshot/file1.<time=
stamp>
> =A0 =A0<timestamp>
> =A0 =A0? snapshot file1 test =A0# Creates /mnt/ocfs2/.snapshot/file1.=
test
> =A0 =A0test
> =A0 =A0? snapshot list file1
> =A0 =A0Snapshots for file1:
> =A0 =A0 =A0 =A0<timestamp>
> =A0 =A0 =A0 =A0test
>
> Something like that.
> =A0 =A0 =A0 =A0A different snapshot model like ext4 could have snapsh=
ot.ext4(8)
> call the kernel or whatever mechanism was appropriate. =A0A filesyste=
m
> from a NAS filer could use filer-specific calls.
> =A0 =A0 =A0 =A0Beyond that, I wanted snapshot(8) to handle scheduling=
 of
> snapshots. =A0The usual daily/weekly stuff should be easy to schedule
> generically.
> =A0 =A0 =A0 =A0That's my brain dump. =A0I could enumerate proposed co=
mmand
> syntaxes, but I don't think that's necessary.
>

No need for that. snapshot(8) API sounds good.
Let's sit together in LSF with btrfs representatives and finalize this =
API.
=46or ext4, I just need for the 'file' arg to be optional.
I would like to include some API to attach a snapshot to a namespace
(mount it in my case) and to see how the inode level snapshots namespac=
e
and volume level snapshots namespace will appear the same to the end-us=
er.

I suppose further discussion on the subject should exclude lsf ml,
which appear to be very hectic these days, so anyone who likes to join =
this
thread, please say so now.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
