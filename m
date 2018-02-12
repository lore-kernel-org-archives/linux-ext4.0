From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH RFC v2 00/13] NLS/UTF-8 Case-Insensitive lookups for ext4 and VFS proposal
Date: Mon, 12 Feb 2018 17:56:22 -0200
Message-ID: <87lgfy2d95.fsf@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
        <20180125031650.GU13338@ZenIV.linux.org.uk>
        <87po5ij1nu.fsf@collabora.co.uk>
        <b90a4183-6b22-2864-d484-9fd3e30543d0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Al Viro <viro@ZenIV.linux.org.uk>, <tytso@mit.edu>,
        <david@fromorbit.com>, <olaf@sgi.com>,
        <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <alvaro.soliverez@collabora.co.uk>, <kernel@lists.collabora.co.uk>,
        hutj <hutj@huawei.com>
To: Gao Xiang <gaoxiang25@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41068 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbeBLT4a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2018 14:56:30 -0500
In-Reply-To: <b90a4183-6b22-2864-d484-9fd3e30543d0@huawei.com> (Gao Xiang's
        message of "Tue, 6 Feb 2018 11:21:44 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Gao Xiang <gaoxiang25@huawei.com> writes:

> Could I express my opinion? I have working on case-insensitive sdcardfs
> for months.

Hi Gao,

Thanks for helping out with this topic.

> I think your problem is how we optimise a case-insensitive lookup on the
> file system with a case-sensitive dcache (I mean d_add and no d_compare
> and d_hash).

Are d_compare and d_hash to be considered really disruptive
performance-wise?  Even if they are only used when casefold/encoding
support is enabled?  I don't see how we could better use the dcache
without at least requiring these functions to handle CI cases.

> In that case, we could not trust the negative dentry when _creating_ a
> case-insensitive file, for example:
>    there exists "anDroid" on-disk, but ext4's in-memory dcache only has
> the negative "Android", if we lookup "Android" we will get the
> _negative_ dentry, but we _cannot_ create it since "anDroid" exists on
> disk. In the create case, an on-disk _iterate_ (or readdir) is
> necessary.

In my previous email, I mentioned my current implementation ignores
negative dentries and forces a ->lookup(), which walks over the disk
entries.  (I had to add a fix to the creation path in the vfs-ms_casefold
branch to exactly match that description, so you might have missed the
updated version in that branch).

Either way, this case is supported like this:

If we have two bind-mounts of the same directory, /mnt and /mnt-ci,
case-sensitive and case-insensitive, respectively,  We can do:

open("/mnt/anDroid", O_EXCL|O_CREAT) = 3
open("/mnt/Android", 0) = -2 No such file or directory
open("/mnt-ci/Android", 0) = 4
open("/mnt-ci/Android", O_EXCL|O_CREAT) = -17 File exists
open("/mnt-ci/AndROID", O_EXCL|O_CREAT) = -17 File exists

The second open() is expected to create an negative_dentry of "Android",
which, if it wasn't ignored by the 3th open(), the CI operation would
have failed.  Notice that the 3th open() operation actually opens the
file that was created by the first open().  It doesn't create a new
file.

Following on, the 4th operation (file creation) *must fail* because
there is a CI name collision with /mnt-ci/anDroid.  The same is true for
the final case.

> I could give another example, if we uses case-insentive ext4 and create
> "Android" and "anDroid", how to deal with the case in the
> case-insensitive way?
>    I mean in that case we should make both "Android" and "anDroid" can
> access, right?

Not sure if I follow you here, but I'm assuming we create Android and
anDroid in the sensitive mountpoint, because, otherwise the
second file creation in the insensitive mountpoint would fail.

This is the case where I'm hiding one of the previously (CS) created
files, when in the insensitive mountpoint, and the user is shooting
himself.  For the sensitive case, Both stays visible to the user.

>    I think we need to build a special case-sensitive dcache rather than
> a case-insensitive dcache following the native case-insentive fs(use
> d_add_ci, d_compare and d_hash, eg. fat, ntfs...)

What do you think about the second part of my proposal, where I mention
dealing differently with negative dentries created by a CI lookup?
We don't need to ignore them if we can invalidate them after a creation
in the directory.

> Finally, I agree "let the user shot herself in the foot by having two
> files with the exact CI name", but I think it could not the VFS
> _busniess_ itself since each customer solution "case-sensitive ext4 -> 
> case-insensitive lookup" has their _perfered_ way (for example,
> "android" and "Android" exist, A perfers android and B perfers Android.

I don't see how we could defer the decision to the filesystem, that's a
pretty good problem, which I don't have a solution right now.

> Finally, I think for optmization, ext4 or other fs could add some dir
> inode _tag_ and supports native case-insensitive for these dirs could be
> better....

Agreed. But I'm seeing this as outside the scope of my proposal, since it
is specific to each filesystem.  My ext4 adaptation, for instance, falls
back to linear search when it can't find the exact match.

Thanks,

-- 
Gabriel Krisman Bertazi
