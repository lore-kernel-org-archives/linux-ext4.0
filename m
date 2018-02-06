From: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH RFC v2 00/13] NLS/UTF-8 Case-Insensitive lookups for ext4
 and VFS proposal
Date: Tue, 6 Feb 2018 11:21:44 +0800
Message-ID: <b90a4183-6b22-2864-d484-9fd3e30543d0@huawei.com>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
 <20180125031650.GU13338@ZenIV.linux.org.uk> <87po5ij1nu.fsf@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <david@fromorbit.com>, <olaf@sgi.com>,
        <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <alvaro.soliverez@collabora.co.uk>, <kernel@lists.collabora.co.uk>,
        hutj <hutj@huawei.com>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87po5ij1nu.fsf@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Gabriel,

On 2018/2/6 10:24, Gabriel Krisman Bertazi wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
>> On Thu, Jan 25, 2018 at 12:53:36AM -0200, Gabriel Krisman Bertazi wrote:
>>
>>> The second proposal is related to the VFS layer:
>>>
>>> (2) Enable Insensitive lookup support on a per-mountpoint basis,
>>> via a MS_CASEFOLD flag, with the ultimate goal of supporting a
>>> case-insensitive bind mount of a subtree, side-by-side with a
>>> sensitive version of the filesystem.
>>
>> First reaction: No.  With the side of HELL NO.
>>
>> Your ultimate goal sounds utterly insane - dcache tree must be shared
>> for all mounts.  Moreover, "would these two names refer to the same
>> object" can not be mount-dependent.  Not going to happen.
>>
>> Please, post the description of what you are planning to do.
>> Detailed.  I'm not saying that it's 100% impossible to do correctly,
>> but I'm _very_ sceptical about the feasibility.
>>
>> I'm certainly not going to ACK any VFS changes until you convince
>> me that this thing can be done with sane semantics.
> 
> Hi Viro,
> 
> Sorry for the delay.  I wanted to get a better understanding of the
> code before getting back to you.
> 
> Our customer is interested in exposing a subtree of an existing
> filesystem (native Linux filesystems, xfs, ext4 and others) in an
> case-insensitive lookup manner, without paying the cost of a userspace
> getdents implementation, and, preferably, without requiring the user to
> modify data on the disk.
Could I express my opinion? I have working on case-insensitive sdcardfs 
for months.

I think your problem is how we optimise a case-insensitive lookup on the 
file system with a case-sensitive dcache (I mean d_add and no d_compare 
and d_hash).
In that case, we could not trust the negative dentry when _creating_ a 
case-insensitive file, for example:
    there exists "anDroid" on-disk, but ext4's in-memory dcache only has 
the negative "Android", if we lookup "Android" we will get the 
_negative_ dentry, but we _cannot_ create it since "anDroid" exists on 
disk. In the create case, an on-disk _iterate_ (or readdir) is necessary.

I could give another example, if we uses case-insentive ext4 and create
"Android" and "anDroid", how to deal with the case in the 
case-insensitive way?
    I mean in that case we should make both "Android" and "anDroid" can 
access, right?
    I think we need to build a special case-sensitive dcache rather than 
a case-insensitive dcache following the native case-insentive fs(use 
d_add_ci, d_compare and d_hash, eg. fat, ntfs...)

Finally, I agree "let the user shot herself in the foot by having two 
files with the exact CI name", but I think it could not the VFS 
_busniess_ itself since each customer solution "case-sensitive ext4 -> 
case-insensitive lookup" has their _perfered_ way (for example, 
"android" and "Android" exist, A perfers android and B perfers Android.

Finally, I think for optmization, ext4 or other fs could add some dir 
inode _tag_ and supports native case-insensitive for these dirs could be 
better....

Sorry to bother,

Thanks,

> 
> After learning, last year, about the similar Android issue from Ted at a
> conference, I started to believe a bind mount is the appropriate
> solution for both our use cases.
> 
> Like Ted mentioned, we let the user shot herself in the foot by having
> two files with the exact CI name, and which one she gets will be
> undefined.  My current solution gets the exact match if it is present,
> and my second approach could be adapted to do that with a performance
> cost only if both files are not cached.  That seem to be acceptable by
> Ted and shouldn't be a problem for me too.
> 
> Let me start by discussing what I have now, which is a functional
> solution, to the best of my knowledge, but which still requires rework
> to better benefit from the dentry cache.  Then I will discuss the
> solutions I am working on.
> 
> (1) What I have now:
> 
> As I mentioned in the first email, MS_CASEFOLD triggers a MNT_CASEFOLD
> flag in the vfsmount structure.  This flag, which gets recalculated
> every time a mountpoint is traversed, is used to decide if we do a
> casefolded ->lookup() for each component of the path.  This obviously
> allows paths with multiple nested mountpoints to work.
> 
> The ->lookup() function calls d_add_ci(), making sure that only the
> exact-match dentry is inserted in the cache.  This means that we don't
> have multiple dentries, differing only by case, associated to the same
> file.  This is an important semantic, which I am not modifying.  This
> also means that a following CI lookup with an inexact-case match will
> trigger another ->lookup(), which is bad, but is manageable (for now).
> I address this problem later in this email.
> 
> Regarding negative dentries.  If we have a negative dentry in the cache,
> the case-sensitive algorithm will abort the lookup and return the
> dentry, nothing new here.  If, on the other hand, That component lookup
> is under a MNT_CASEFOLD search, the code does a bigger effort, ignores
> the negative dentry and still do ->lookup().
> 
> This means that:
> 
>   - Case-sensitive (CS) search performance is not affected, except for
>     the following sequence: Do a CS(foo) which returns a negative_dentry,
>     then CI(FOO), and finally CS(foo).  This will require the second
>     CS(foo) to re-do the search and recreate the negative dentry.  If
>     only CS searches are done, the performance should be unaffected.
> 
>   - Case-insensitive (CI) benefits from the dentry cache as long as it is
>   doing an exact-case name match.  Otherwise, it always falls to
>   ->lookup().  The exact-name dentry, if already in the cache, will be
>   returned in both cases.
> 
>   - Negative dentries are ignored if doing CI and it always re-do the
>     search.
> 
> The prototype code is in the following branch.  I can send
> patches if you want.
> 
>   https://gitlab.collabora.com/krisman/linux.git -b vfs-ms_casefold
> 
> (2) What I want to do:
> 
> I want to allow lookups of the inexact name to find the cached dentry,
> preventing it from going to the disk only to find out later it already
> has that dentry cached in some other cache bucket.  This means that,
> whenever there is a MNT_CASEFOLD enabled, every mountpoint of that
> superblock needs to use d_hash(casefold(name)), such that every file is
> in a known bucket.  Obviously this is a worse hash function, but the
> cost is only payed by filesystems using the feature.  If a bind mount is
> done, we must rehash all existing entries of that filesystem at
> "bind,remount,ignorecase" time.
> 
> Like the previous version, we only store exact name dentries, even
> though the bucket is different now.  When doing a LOOKUP_CASEFOLD, we
> use a different ->d_compare_CI() to do the matching, such that we can
> find the right dentry or not, in both scenarios (CI and CS).
> 
> We still can't trust negative dentries when doing a CI lookup. Consider
> the case where we do CS(FOO) and foo doesn't exist. Now we have a
> negative_dentry(FOO), but CI(FOO) would still need to find an existing
> 'foo' file.  The first solution is to make fast_CI_lookup() walk the
> entire bucket and ignore previous matching negative dentries if a
> positive one is found.  If no positive dentry is found, then fallback
> and do ->lookup().  A superior solution is to mark negative dentries as
> soft negatives and hard negatives, depending on what kind of lookup
> created the dentry, whether CS or CI, respectively.  Then, we can allow
> a CI lookup to return the negative dentry only if it is a HARD negative,
> and try the ->lookup() otherwise.  For this to work, any dentry creation
> on that parent requires that we invalidate hard negative children
> dentries, and make them soft, at insertion/rename time.
> 
> With these changes I believe the dentry cache could be shared by code
> doing CI and CS lookups of the same dentry.  My main concern is whether
> we could invalidate a negative dentry without harming parallel lookups
> using that dentry, but I believe I can work around that.
> 
> I believe this covers everything I could identify, but please let me
> know if I missed something, obvious or not.
> 
