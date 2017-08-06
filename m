From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH v2] ext4: reduce lock contention in __ext4_new_inode
Date: Sun, 6 Aug 2017 08:15:50 +0800
Message-ID: <CAP9B-QmWafivoY9HxQhob6MBYOQm=CPXm_fgj7sfvBSz82Q9zA@mail.gmail.com>
References: <20170805030436.32314-1-wshilong@ddn.com> <20170805170353.sorq6n6qrfeadhop@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Wang Shilong <wshilong@ddn.com>, adilger@dilger.ca,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33782 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdHFAPv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Aug 2017 20:15:51 -0400
Received: by mail-yw0-f196.google.com with SMTP id u207so3047216ywc.0
        for <linux-ext4@vger.kernel.org>; Sat, 05 Aug 2017 17:15:51 -0700 (PDT)
In-Reply-To: <20170805170353.sorq6n6qrfeadhop@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 6, 2017 at 1:03 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Aug 05, 2017 at 11:04:36AM +0800, Wang Shilong wrote:
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 507bfb3..19323ea 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -957,8 +957,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>>               if (!ret2)
>>                       goto got; /* we grabbed the inode! */
>>  next_inode:
>> -             if (ino < EXT4_INODES_PER_GROUP(sb))
>> +             if (ino < EXT4_INODES_PER_GROUP(sb)) {
>> +                     /* Lock contention, relax a bit */
>> +                     if (ext4_fs_is_busy(sbi))
>> +                             schedule_timeout_uninterruptible(
>> +                                             msecs_to_jiffies(1));
>>                       goto repeat_in_this_group;
>> +             }
>>  next_group:
>>               if (++group == ngroups)
>>                       group = 0;
>
> We should probably ne not even doing the lock contention in the case
> where the reason why we've jumped to next_inode is because we failed
> the recently_deleted() test.  But that can be fixed by changing the
> "goto next_inode" in the recently_deleted() codepath with:
>
>                         if (ino < EXT4_INODES_PER_GROUP(sb))
>                                 goto repeat_in_this_group;
>

Yup, you are right, i thought about that in the first patch, but missed
it when v2.


> Also while I agree that it's better to use ext4_fs_is_busy(), the
> exact details of when we will sleep for a second are different.  So it
> would be good for you to rerun your benchmarks; since the numbers in
> your v1 and v2 patch were the same, it's not clear to me that you did
> rerun them.  Can you confirm one way or another?  And rerun them for
> the v3 version of the patch?

We indeed should rerun benchmark, thanks for your timely feedback, will
rebenchmark as you suggested.


>
> Many thanks,
>
>                                                 - Ted
