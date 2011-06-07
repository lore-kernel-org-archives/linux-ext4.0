From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 19:46:03 +0300
Message-ID: <BANLkTik74BM_TZin7rSXDRo1YftBsT-yYw@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<4DEE4333.9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38305 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1FGQqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 12:46:06 -0400
Received: by wwa36 with SMTP id 36so5136325wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 09:46:04 -0700 (PDT)
In-Reply-To: <4DEE4333.9@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 6:26 PM, Josef Bacik <josef@redhat.com> wrote:
> On 05/09/2011 12:41 PM, amir73il@users.sourceforge.net wrote:
>> The following patch series includes all the changes to core ext4 fil=
es,
>> which are needed for snapshots support. It adds some ~2K lines of co=
de,
>> which will never be executed unless the following 2 conditions apply=
:
>> 1. ext4 is built with CONFIG_EXT4_FS_SNAPSHOT
>> 2. HAS_SNAPSHOT and EXCLUDE_BITMAP features are set by mke2fs/tune2f=
s
>>
>> The remaining ~5K lines of code, added in new snapshot* files, were =
omitted
>> from this series to simplify the review and becasue they are not nee=
ded
>> when building ext4 without CONFIG_EXT4_FS_SNAPSHOT.
>> the full patches will be posted soon after I recieve some comments.
>>
>> Ted has concluded my ext4 snapshots talk on LPC 2010 with the statem=
ent that
>> as long as the snapshot patches don't break anything when snapshot s=
upport
>> is disabled, he will pull them, so the main goal when reviewing this=
 series
>> should be to prove that it is safe to pull the patches.
>>
>> REVIEWING
>> ---------
>> To make it easy for reviewers, I will provide some pointers:
>> - EXT4_SNAPSHOTS(sb) is defined to (0) (in snapshot.h) when ext4 is =
built
>> =A0 without snapshots support.
>> - EXT4_SNAPSHOTS(sb) is defined to test the HAS_SNAPSHOT feature whe=
n ext4
>> =A0 is built with snapshots support.
>> - All the ext4_snapshot_XXX function added by the patches, are defin=
ed to
>> =A0 NOP macros in snapshot.h when ext4 is built without snapshots su=
pport.
>> - Various flags defined by the patches (like EXT4_MB_HINT_COWING) wi=
ll never
>> =A0 get set if EXT4_SNAPSHOTS(sb) is false, so testing them will als=
o be false.
>>
>> MERGING
>> -------
>> These patches are based on Ted's current master branch + alloc_semp =
removal
>> patches. Although the alloc_semp removal is an independent (and in m=
y eyes
>> a good) change, it is also required by snapshot patches, to avoid ci=
rcular
>> locking dependency during COW allocations.
>>
>> Merging with Allison's punch holes patches should be straight forwar=
d, since
>> the hard part, namely Yongqiang's split extent refactoring patches, =
was
>> already merged by Ted.
>>
>> Merging with Ted's big alloc patches is going to be a bit more chall=
enging,
>> since big alloc patches make a lot of renaming and refactoring. Howe=
ver,
>> since has_snapshots and big_alloc features will never work together,
>> at least testing the code together is not a big concern.
>>
>> TESTING
>> -------
>> Apart from the extensive testing for the snapshots feature functiona=
lity, we
>> also ran xfstests with snapshots and while taking a snapshot every 1=
 minute.
>> More importantly, we ran xfstests with snapshots support disabled in=
 compile
>> time and with snapshot support enabled but without has_snapshot feat=
ure.
>> These xfstests were run with blocksize 1K and 4K and on X86 and X86_=
64.
>> The 1K blocksize tests are important for the alloc_semp removal patc=
hes.
>> No problems were found apart from one (test 225 hung), which is alre=
ady
>> existing in master branch.
>>
>> CREDITS
>> -------
>> The snapshots patches originate in my implementation of the Next3 fi=
lesystem
>> for CTERA networks.
>> The porting of the Next3 snapshot patches to ext4 patches is attribu=
ted to
>> Aditya Dani, Shardul Mangade, Piyush Nimbalkar and Harshad Shirwadka=
r from
>> the Pune Institute of Computer Technology (PICT).
>> The implementation of extents move-on-write, delayed move-on-write a=
nd much
>> of the cleanup work on these patches was carried out by Yongqiang Ya=
ng from
>> the Institute of Computing Technology, Chinese Academy of Sciences.
>>
>
> I probably should have brought this up before, but why put all this
> effort into shoehorning in such a big an invasive feature to ext4 whe=
n
> btrfs does this all already? =A0Why not put your efforts into helping
> btrfs become stable and ready and then use that, instead of having to
> come up with a bunch of hacks to get around the myriad of weird featu=
re
> combinations you can get with ext4?

Hi Josef,

I understand the bitterness in btrfs community regarding ext4 snapshot
feature. You might say the same things about ext4 64bit feature.
I think it is not up to us to decide how it rolls. it's the users
and companies involved that dictate where the development happens.

I like the answer that Ted once replied to the old btrfs vs. ext4 quest=
ion:
competition is good because it makes us modest.

I believe there is room in the future for both fs's, even with
similar features in both.



>
> The wonderful thing about ext4 is its a nice basic fs. =A0If we're go=
ing
> to start doing lots of crazy things, why not do them to the fs that
> isn't yet in wide use and can afford to have crazy things done to it
> without screwing a bunch of users who already depend on ext4's
> stability? =A0Thanks,
>

As I see it, stability is the *only* advantage of ext4 snapshots over b=
trfs
even though the snapshot feature is new and not stable, you still
have the good olf e2fsprogs tools that can get you out of any mess.
specifically, fsck -x will discard all snapshot files and make your ext=
4
fs clean and stable again.

The repair tool is one thing that btrfs is still lacking, so I back CTE=
RA's
decision to progress to ext4 with snapshots and not to btrfs on a
production system.

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
