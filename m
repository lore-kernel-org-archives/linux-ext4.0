From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 07 Jun 2011 12:54:32 -0400
Message-ID: <4DEE57C8.9090502@redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>	<4DEE4333.9@redhat.com> <BANLkTik74BM_TZin7rSXDRo1YftBsT-yYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab1FGQym (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 12:54:42 -0400
In-Reply-To: <BANLkTik74BM_TZin7rSXDRo1YftBsT-yYw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/07/2011 12:46 PM, Amir G. wrote:
> On Tue, Jun 7, 2011 at 6:26 PM, Josef Bacik <josef@redhat.com> wrote:
>> On 05/09/2011 12:41 PM, amir73il@users.sourceforge.net wrote:
>>> The following patch series includes all the changes to core ext4 files,
>>> which are needed for snapshots support. It adds some ~2K lines of code,
>>> which will never be executed unless the following 2 conditions apply:
>>> 1. ext4 is built with CONFIG_EXT4_FS_SNAPSHOT
>>> 2. HAS_SNAPSHOT and EXCLUDE_BITMAP features are set by mke2fs/tune2fs
>>>
>>> The remaining ~5K lines of code, added in new snapshot* files, were omitted
>>> from this series to simplify the review and becasue they are not needed
>>> when building ext4 without CONFIG_EXT4_FS_SNAPSHOT.
>>> the full patches will be posted soon after I recieve some comments.
>>>
>>> Ted has concluded my ext4 snapshots talk on LPC 2010 with the statement that
>>> as long as the snapshot patches don't break anything when snapshot support
>>> is disabled, he will pull them, so the main goal when reviewing this series
>>> should be to prove that it is safe to pull the patches.
>>>
>>> REVIEWING
>>> ---------
>>> To make it easy for reviewers, I will provide some pointers:
>>> - EXT4_SNAPSHOTS(sb) is defined to (0) (in snapshot.h) when ext4 is built
>>>   without snapshots support.
>>> - EXT4_SNAPSHOTS(sb) is defined to test the HAS_SNAPSHOT feature when ext4
>>>   is built with snapshots support.
>>> - All the ext4_snapshot_XXX function added by the patches, are defined to
>>>   NOP macros in snapshot.h when ext4 is built without snapshots support.
>>> - Various flags defined by the patches (like EXT4_MB_HINT_COWING) will never
>>>   get set if EXT4_SNAPSHOTS(sb) is false, so testing them will also be false.
>>>
>>> MERGING
>>> -------
>>> These patches are based on Ted's current master branch + alloc_semp removal
>>> patches. Although the alloc_semp removal is an independent (and in my eyes
>>> a good) change, it is also required by snapshot patches, to avoid circular
>>> locking dependency during COW allocations.
>>>
>>> Merging with Allison's punch holes patches should be straight forward, since
>>> the hard part, namely Yongqiang's split extent refactoring patches, was
>>> already merged by Ted.
>>>
>>> Merging with Ted's big alloc patches is going to be a bit more challenging,
>>> since big alloc patches make a lot of renaming and refactoring. However,
>>> since has_snapshots and big_alloc features will never work together,
>>> at least testing the code together is not a big concern.
>>>
>>> TESTING
>>> -------
>>> Apart from the extensive testing for the snapshots feature functionality, we
>>> also ran xfstests with snapshots and while taking a snapshot every 1 minute.
>>> More importantly, we ran xfstests with snapshots support disabled in compile
>>> time and with snapshot support enabled but without has_snapshot feature.
>>> These xfstests were run with blocksize 1K and 4K and on X86 and X86_64.
>>> The 1K blocksize tests are important for the alloc_semp removal patches.
>>> No problems were found apart from one (test 225 hung), which is already
>>> existing in master branch.
>>>
>>> CREDITS
>>> -------
>>> The snapshots patches originate in my implementation of the Next3 filesystem
>>> for CTERA networks.
>>> The porting of the Next3 snapshot patches to ext4 patches is attributed to
>>> Aditya Dani, Shardul Mangade, Piyush Nimbalkar and Harshad Shirwadkar from
>>> the Pune Institute of Computer Technology (PICT).
>>> The implementation of extents move-on-write, delayed move-on-write and much
>>> of the cleanup work on these patches was carried out by Yongqiang Yang from
>>> the Institute of Computing Technology, Chinese Academy of Sciences.
>>>
>>
>> I probably should have brought this up before, but why put all this
>> effort into shoehorning in such a big an invasive feature to ext4 when
>> btrfs does this all already?  Why not put your efforts into helping
>> btrfs become stable and ready and then use that, instead of having to
>> come up with a bunch of hacks to get around the myriad of weird feature
>> combinations you can get with ext4?
> 
> Hi Josef,
> 
> I understand the bitterness in btrfs community regarding ext4 snapshot
> feature. You might say the same things about ext4 64bit feature.
> I think it is not up to us to decide how it rolls. it's the users
> and companies involved that dictate where the development happens.
> 

Oh don't misunderstand me, I'm not bitter.  It just seems like this is a
lot of work for something you get for free with btrfs.  A lot of work
which I don't really think is justified when it comes to ext4.

> I like the answer that Ted once replied to the old btrfs vs. ext4 question:
> competition is good because it makes us modest.
> 
> I believe there is room in the future for both fs's, even with
> similar features in both.
> 
> 
> 
>>
>> The wonderful thing about ext4 is its a nice basic fs.  If we're going
>> to start doing lots of crazy things, why not do them to the fs that
>> isn't yet in wide use and can afford to have crazy things done to it
>> without screwing a bunch of users who already depend on ext4's
>> stability?  Thanks,
>>
> 
> As I see it, stability is the *only* advantage of ext4 snapshots over btrfs
> even though the snapshot feature is new and not stable, you still
> have the good olf e2fsprogs tools that can get you out of any mess.
> specifically, fsck -x will discard all snapshot files and make your ext4
> fs clean and stable again.
> 
> The repair tool is one thing that btrfs is still lacking, so I back CTERA's
> decision to progress to ext4 with snapshots and not to btrfs on a
> production system.
> 

Sure, if you had spent time on a fsck tool for btrfs you would be done
by now ;).  I feel that ext4 is becoming a dumping ground for every ones
pet project which is resulting in this weird frankenstien like fs that
is growing organically, rather than a great, stable and all around
useful file system.  Rather than cramming more crap into it, maybe we
should evaluate whether the work is useful in the first place with
things like btrfs or the dm snapshotting stuff exist.  Thanks,

Josef
