From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH RFC v2 00/13] NLS/UTF-8 Case-Insensitive lookups for ext4 and VFS proposal
Date: Tue, 13 Feb 2018 20:20:47 -0200
Message-ID: <8760701qgw.fsf@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
        <20180125031650.GU13338@ZenIV.linux.org.uk>
        <87po5ij1nu.fsf@collabora.co.uk>
        <b90a4183-6b22-2864-d484-9fd3e30543d0@huawei.com>
        <87lgfy2d95.fsf@collabora.co.uk>
        <27719f0e-600b-c7fe-0229-b4204bcf7d77@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Gao Xiang <gaoxiang25@huawei.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, tytso@mit.edu,
        david@fromorbit.com, olaf@sgi.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, alvaro.soliverez@collabora.co.uk,
        kernel@lists.collabora.co.uk, hutj <hutj@huawei.com>
To: Gao Xiang <hsiangkao@aol.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <27719f0e-600b-c7fe-0229-b4204bcf7d77@aol.com> (Gao Xiang's
        message of "Tue, 13 Feb 2018 06:43:10 +0800")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Gao Xiang <hsiangkao@aol.com> writes:

> Hi Gabriel,
>
> Thanks for your reply.
>
> On 2018/2/13 3:56, Gabriel Krisman Bertazi wrote:
>> Gao Xiang <gaoxiang25@huawei.com> writes:
>>
>>> Could I express my opinion? I have working on case-insensitive sdcardfs
>>> for months.
>> Hi Gao,
>>
>> Thanks for helping out with this topic.
>>
>>> I think your problem is how we optimise a case-insensitive lookup on the
>>> file system with a case-sensitive dcache (I mean d_add and no d_compare
>>> and d_hash).
>> Are d_compare and d_hash to be considered really disruptive
>> performance-wise?  Even if they are only used when casefold/encoding
>> support is enabled?  I don't see how we could better use the dcache
>> without at least requiring these functions to handle CI cases.
> I mean if both "Android" and "anDroid" exist in the same directory of
> on-disk ext4,
> I could tend to make both "Android" and "anDroid" accessed by
> the case-exact name lookup, otherwise do a case-insensitive
> lookup. eg. (my current implementation),
> 1. open("/mnt/anDroid", O_EXCL|O_CREAT)
> 2. open("/mnt/Android", O_EXCL|O_CREAT)
> 3. open("/mnt-ci/Android") --- exactly Android
> 4. open("/mnt-ci/anDroid") --- exactly anDroid
> 5. open("/mnt-ci/ANDROID") --- Android or anDroid, do a case-insensitive
> lookup.
> 6. unlink("/mnt-ci/Android") --- exactly Android
> 7. unlink("/mnt-ci/ANDROID") --- anDroid, do a case-insensitive lookup.

Hmm, let me correct what I said before.  My code is not fetching the
exact-match in this case, it always returns the result of a CI lookup.

Still, I adapted it last night to return the exact-case file, by
touching the lookup hook itself, which I believe allows it to be made a
filesystem decision, despite being much more expensive.

Apart from that, can we revisit this design decision ?  It feels a bit
awkward that we can change the file returned by the lookup by doing an
unlink() or creat() on the other mountpoint.

$ echo foo > /mnt/bla
$ cat /mnt-ci/BLA
foo
$ echo bar > /mnt/BLA
$ cat /mnt-ci/BLA     <--- Same lookup has different result now
bar

This seems awfully confusing.  Maybe that's the nature of CI, but,
wouldn't entirely hiding the duplicated file be less confusing?  Is
there any benefit or use case that requires this behavior?


>>> In that case, we could not trust the negative dentry when _creating_ a
>>> case-insensitive file, for example:
>>>     there exists "anDroid" on-disk, but ext4's in-memory dcache only has
>>> the negative "Android", if we lookup "Android" we will get the
>>> _negative_ dentry, but we _cannot_ create it since "anDroid" exists on
>>> disk. In the create case, an on-disk _iterate_ (or readdir) is
>>> necessary.
>> In my previous email, I mentioned my current implementation ignores
>> negative dentries and forces a ->lookup(), which walks over the disk
>> entries.  (I had to add a fix to the creation path in the vfs-ms_casefold
>> branch to exactly match that description, so you might have missed the
>> updated version in that branch).
> I am sorry, I haven't looked into your CI patch yet.
>
> I decided to join in this topic because in the past months, I did some work
> on the case-insensitive sdcardfs, and I just want to express my thoughts
> for this topic.
>
> I don't know which level negative dentries you ignore, your
> case-insensitive negative dentries
> or the original underlayfs(eg. ext4) case-sensitive negative dentries?

I'm talking about the existing case-sensitive negative dentries.  I'm
not adding any dentries other than the ones created by the underlayfs

> Actually I observed some false "negative dentries" race or deadlock
> if multiple case-insensitive mounts exist and do fs-ops on these mounts
> at the same time,
> but I am not sure whether your implementation has these potential issues
> in principle or not.

Do you have a test case?  I didn't observe that, but I might not be
stressing my code enough.

>
> In addition, quote `
> Our customer is interested in exposing a subtree of an existing
> filesystem (native Linux filesystems, xfs, ext4 and others) in an
> case-insensitive lookup manner, without paying the cost of a userspace
> getdents implementation, and, preferably, without requiring the user to
> modify data on the disk.`
>
> I think the *most expensive* operation for case-insensitive lookup is to
> create a not-exist file rather than do a existed-file lookup.
> It takes much overhead and I think no straightforward way to directly
> reduce the cost
> and improve its performance.
>
>>
>> Either way, this case is supported like this:
>>
>> If we have two bind-mounts of the same directory, /mnt and /mnt-ci,
>> case-sensitive and case-insensitive, respectively,  We can do:
>>
>> open("/mnt/anDroid", O_EXCL|O_CREAT) = 3
>> open("/mnt/Android", 0) = -2 No such file or directory
>> open("/mnt-ci/Android", 0) = 4
>> open("/mnt-ci/Android", O_EXCL|O_CREAT) = -17 File exists
>> open("/mnt-ci/AndROID", O_EXCL|O_CREAT) = -17 File exists
>>
>> The second open() is expected to create an negative_dentry of "Android",
>> which, if it wasn't ignored by the 3th open(), the CI operation would
>> have failed.  Notice that the 3th open() operation actually opens the
> Yes, the 3th open() should invalidate the 2nd negative dentry.
> However, I don't know your detailed implementation behavior, for example
> as follows:
>
> 1. open("/mnt/anDroid", O_EXCL|O_CREAT)
> 2. open("/mnt/Android", 0)                 ---- dentry A
> 3. open("/mnt-ci/Android", 0)             ---- CI-dentry B or the same
> dentry A?
>
> if 2 and 3 are the different denties but the same inode, furthermore,
> if the inode is a directory inode, it seems like a hard link directory,
> any *potential deadlock* with that?

2 and 3 are the same dentry, not a duplicate or anything else.  The
point is to avoid dealing with multiple dentries kind of complexity.


> and how about?
> 1. open("/mnt/anDroid", O_EXCL|O_CREAT)             --- inode A
> 2. close("/mnt/anDroid") --- still positive, referenced
> 3. open("/mnt/Android", 0) --- No such file or directory
> 4. open("/mnt-ci/Android", 0) --- positive, inode A
> 5. close("/mnt-ci/Android") --- still positive, referenced
> 6. open("/mnt/android", O_EXCL|O_CREAT)             --- inode B
> 7. unlink("/mnt/anDroid")   --- expected behavior? since we have 2) and
> 5) referenced, can the inode finally be evicted? ---
> 8. open("/mnt-ci/Android", 0) --- ??? positive and inode B? ---

If I understand correctly, since the dentry recovered by 1 and 4 are the
same, 7 should unlink /mnt/anDroid and make it negative, since there are
no more references.

Since /mnt/anDroid no longer exists we are sure that step 8. when
accessing /mnt-ci/Android will return inode B, since that is the only
one remaining.  I think this is it.

>> file that was created by the first open().  It doesn't create a new
>> file.
>>
>> Following on, the 4th operation (file creation) *must fail* because
>> there is a CI name collision with /mnt-ci/anDroid.  The same is true for
>> the final case.
>>
>>> I could give another example, if we uses case-insentive ext4 and create
>>> "Android" and "anDroid", how to deal with the case in the
>>> case-insensitive way?
>>>     I mean in that case we should make both "Android" and "anDroid" can
>>> access, right?
>> Not sure if I follow you here, but I'm assuming we create Android and
>> anDroid in the sensitive mountpoint, because, otherwise the
>> second file creation in the insensitive mountpoint would fail.
>>
>> This is the case where I'm hiding one of the previously (CS) created
>> files, when in the insensitive mountpoint, and the user is shooting
>> himself.  For the sensitive case, Both stays visible to the user.
> As I mentioned above....
> 1. open("/mnt/anDroid", O_EXCL|O_CREAT) 
> 2. open("/mnt/Android", O_EXCL|O_CREAT)
> 3. open("/mnt-ci/Android") --- exactly "Android"
> 4. open("/mnt-ci/anDroid") --- exactly "anDroid"
> 5. open("/mnt-ci/ANDROID") --- "Android" or "anDroid", do a
> case-insensitive lookup.
> 6. unlink("/mnt-ci/Android") --- exactly "Android"
> 7. unlink("/mnt-ci/ANDROID") --- "anDroid", do a case-insensitive
> lookup.

This depends on my question about the behavior of doing an exact name
lookup.

>
>>>     I think we need to build a special case-sensitive dcache rather than
>>> a case-insensitive dcache following the native case-insentive fs(use
>>> d_add_ci, d_compare and d_hash, eg. fat, ntfs...)
>> What do you think about the second part of my proposal, where I mention
>> dealing differently with negative dentries created by a CI lookup?
>> We don't need to ignore them if we can invalidate them after a creation
>> in the directory.
> I feel some complex of your second part... I still need some time to
> look into that...
> and I think it is useless of negative dentries for that case
> intuitively.....
>>
>>> Finally, I agree "let the user shot herself in the foot by having two
>>> files with the exact CI name", but I think it could not the VFS
>>> _busniess_ itself since each customer solution "case-sensitive ext4 ->
>>> case-insensitive lookup" has their _perfered_ way (for example,
>>> "android" and "Android" exist, A perfers android and B perfers Android.
>> I don't see how we could defer the decision to the filesystem, that's a
>> pretty good problem, which I don't have a solution right now.
>>
>>> Finally, I think for optmization, ext4 or other fs could add some dir
>>> inode _tag_ and supports native case-insensitive for these dirs could be
>>> better....
>> Agreed. But I'm seeing this as outside the scope of my proposal, since it
>> is specific to each filesystem.  My ext4 adaptation, for instance, falls
>> back to linear search when it can't find the exact match.
>>
>> Thanks,
>>
> I could miss something important, if I recall, I will reply in the
> future....
>
> Thanks,

-- 
Gabriel Krisman Bertazi
