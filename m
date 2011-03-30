From: Tao Ma <tm@tao.ma>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 30 Mar 2011 13:52:08 +0800
Message-ID: <4D92C508.7010404@tao.ma>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>	<20110204002043.GA15658@noexit>	<AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>	<20110330003429.GA32669@noexit> <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Joel Becker <jlbec@evilplan.org>, lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:48574 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750972Ab1C3FwK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2011 01:52:10 -0400
In-Reply-To: <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Amir,
On 03/30/2011 12:16 PM, Amir Goldstein wrote:
> On Wed, Mar 30, 2011 at 2:34 AM, Joel Becker <jlbec@evilplan.org> wrote:
>> On Wed, Mar 23, 2011 at 10:19:38PM +0200, Amir Goldstein wrote:
>>> On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> wrote:
>>>> On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
>>>>        I've already got a design for a front-end snapshot program that
>>>> implements a policy on top this generic behavior.  This design would
>>>> cover both first-class and hidden style snapshots, because it assume
>>>> snapshots are in a distinct namespace.  I haven't gotten around to
>>>> implementing it yet, but btrfs and other snapshottable filesystems were
>>>> part of the design goal.
>>>
>>> Any chance of getting a copy of that design of yours, to get a head start
>>> for LSF?
>>
>>        Yeah, I owe it to you.  It wasn't a written-down thing, it was a
>> hammered-out-in-our-heads thing among some ocfs2 developers.  I'm going
>> to braindump here to get us going.  First, I'll speak to your points.
>>
>>> Here are some other generic snapshot related topics we may want to discuss:
>>>
>>> 1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggested by Chris.
>>
>>        I'm unsure where these fit, perhaps because I missed the
>> discussion between Chris and you.  ocfs2 has the inode flag
>> OCFS2_REFCOUNTED_FL to signify a refcount tree is attached to the inode.
>> This is ocfs2's structure for maintaining extent reference counts.  Is
>> your COW_FL the same?  Or is it a permission flag?  NOCOW_FL sounds
>> like: "Set this flag on the inode and it will prevent CoW."
> 
> I don't have a use for COW_FL, since my snapshots are volume level snapshots.
> I intend to use NOCOW_FL to mark an inode as an "island" of NOCOW
> blocks in the volume.
> Maybe Chris or Josef can elaborate of the flags intended use in btrfs.
> 
>>
>>> 2. How to deal with mmap write to COW file, when you get ENOSPC.
>>
>>        We just fail the write with VM_FAULT_SIGBUS like mmap write to a
>> hole.  It's what happens for most other CoW filesystems today.  If
>> you're using CoW, you should be aware of what to expect.
>>
> 
> "you", meaning a CoW fs developer? a CoW fs administrator? or an application
> developer, who has no idea what fs the application will be on?
> I know it is easy for us to say "there is no solution", but I have
> actually implemented
> a block reservation technique that may be useful in this case...
> it's hammered-out-in-my-head, so let's save me the brain dump and I'll tell
> you about it in person...
> 
> 
>>> 3. Adding buffer_remap() flag for buffered I/O code, meaning, there is
>>> an existing mapping to initialize a page on partial write, but still need
>>> to call get_block() to get a (possibly) new mapping.
>>
>>        Since ocfs2 doesn't allocate in get_block(), this doesn't affect
>> us.  We notice the refcounted extent in write_begin() and CoW it right
>> there.  Same place we clean up unwritten extents.
>>
> 
> Yes, I was going to write a specialized block_write_begin() for CoW,
> but I like to use existing generic code when possible and block_write_begin()
> is only a few lines of code short of what I need, so maybe we can all use it?
> 
> 
>> --snip--
>>
>>        Now, about my snapshot thoughts as promised.  My understanding
>> of the snapshots you have implemented in ext4 is that they are like some
>> SAN snapshots; they are hidden objects not visible unless you use
>> special access.  They are particular to a given inode and are children
>> of that inode.  What happens when you remove the visible inode?  Do the
>> snapshots disappear?  Do you have limitations on how many shapshots a
>> particular inode can have?  These questions plagued us when we original
>> set out to design inode snapshots for ocfs2.
> 
> ext4 snapshots are volume level (readonly) snapshots.
> the snapshot inodes are both the "place-holder" of private snapshot blocks
> and the (loopdev) mount point to access the volume snapshot.
> This is why I wondered if inode level snapshots and volume/subvolume
> level snapshots can share the same API.
> BTW, does btrfs have inode level snapshots as well?
> 
>>        Once we settled on a mechanism for CoW among ocfs2 inodes, we
>> quickly decided that a snapshot should be visible in the namespace.
>> This gave rise to the reflink(2) call, though that name is deprecated in
>> favor of fastcopy(2).  Currently our API is OCFS2_IOC_REFLINK (see,
>> legacy!), but we eventually want to get the system call upstream.  In
>> ocfs2-land, we decided to keep policy out of the kernel.
>> OCFS2_IOC_REFLINK creates a new inode that shares all the extents of the
>> source in CoW fashion, but once it returns, that new inode is a peer of
>> the source.  There is no parent->child relationship.
>>        Thus, for ocfs2 (and forgive the legacy names, the binary hasn't
>> changed yet), a "snapshot" is just:
>>
>>    snapshot: reflink source target.snap && chmod 0444 target.snap
>>
>> You can add "chattr +i target.snap" in there if you like.
>>        Since there is no "snapshot namespace" stuff for ocfs2 in the
>> kernel, it was our intention to propose a snapshot(8) binary that works
>> like mkfs/fsck; snapshot(8) just calls snapshot.<fstype>(8).  Our
>> plan was to place snapshot policy in snapshot.ocfs2(8).  This
>> implementation would handle managing the <mountpoint>/.snapshot/...
>> namespace behind the user:
>>
>>    ? cd /mnt/ocfs2
>>    ? snapshot file1  # Creates /mnt/ocfs2/.snapshot/file1.<timestamp>
>>    <timestamp>
>>    ? snapshot file1 test  # Creates /mnt/ocfs2/.snapshot/file1.test
>>    test
>>    ? snapshot list file1
>>    Snapshots for file1:
>>        <timestamp>
>>        test
>>
>> Something like that.
>>        A different snapshot model like ext4 could have snapshot.ext4(8)
>> call the kernel or whatever mechanism was appropriate.  A filesystem
>> from a NAS filer could use filer-specific calls.
>>        Beyond that, I wanted snapshot(8) to handle scheduling of
>> snapshots.  The usual daily/weekly stuff should be easy to schedule
>> generically.
>>        That's my brain dump.  I could enumerate proposed command
>> syntaxes, but I don't think that's necessary.
>>
> 
> No need for that. snapshot(8) API sounds good.
> Let's sit together in LSF with btrfs representatives and finalize this API.
> For ext4, I just need for the 'file' arg to be optional.
> I would like to include some API to attach a snapshot to a namespace
> (mount it in my case) and to see how the inode level snapshots namespace
> and volume level snapshots namespace will appear the same to the end-user.
> 
> I suppose further discussion on the subject should exclude lsf ml,
> which appear to be very hectic these days, so anyone who likes to join this
> thread, please say so now.
I implemented the reflink support in ocfs2, so please cc me when you
open a private thread about this topic. Thanks.

Regards,
Tao
