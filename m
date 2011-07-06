From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all failed mount paths.
Date: Wed, 6 Jul 2011 16:54:45 -0600
Message-ID: <3828C477-0589-402A-8F71-9837FE8B0693@dilger.ca>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com> <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca> <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	Yu Jian <yujian@whamcloud.com>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:39694 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1GFWyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 18:54:47 -0400
In-Reply-To: <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-16, at 11:05 AM, Manish Katiyar wrote:
> On Sun, Jan 16, 2011 at 8:20 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>> Why not just put the iput() at failed_mount4() instead of spread around the code?
> 
> Thanks Andreas, Here is the updated patch.

We are hitting this same problem due to ENOMEM on allocating some large
filesystem structures for 128TB filesystems.  However, when we were going
to add this patch to our patch series (until vendor kernels include it),
Yu Jian (one of our developers) noticed a problem with the patch.

In the error path, the patch is doing:

failed_mount4:
	iput(root);
	sb->s_root = NULL;

but in fact sb->s_root is a dentry allocated by d_alloc_root(), so the
above code is freeing the inode, but still leaking the dentry.  This
is of course a lot better than before (no oops), but still isn't correct.

The original problem appears to have been inadvertently fixed with commit
8aefcd557d26d0023a36f9ec5afbf55e59f8f26b, because ext4_clear_inode() now
checks "if (EXT4_I(inode)->jinode)" before deferencing EXT4_SB() and the
now-NULL s_fs_info.  jinode should be NULL during mount, because it has
never been opened.  I haven't confirmed this theory yet, however.  Manish,
can you please give this a try with your fault-injection testing?

It looks like we could revert 32a9bb57d7c1fd04ae0f72b8f671501f000a0e9f
(this patch, leaving the two explicit iput() in place in case of a bad
root inode or dentry) and leave the VFS to clean up the root dentry.

> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
> fs/ext4/super.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cb10a06..8fa53e9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3522,17 +3522,16 @@ no_journal:
>       if (IS_ERR(root)) {
>               ext4_msg(sb, KERN_ERR, "get root inode failed");
>               ret = PTR_ERR(root);
> +               root = NULL;
>               goto failed_mount4;
>       }
>       if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
> -               iput(root);
>               ext4_msg(sb, KERN_ERR, "corrupt root inode, run e2fsck");
>               goto failed_mount4;
>       }
>       sb->s_root = d_alloc_root(root);
>       if (!sb->s_root) {
>               ext4_msg(sb, KERN_ERR, "get root dentry failed");
> -               iput(root);
>               ret = -ENOMEM;
>               goto failed_mount4;
>       }
> @@ -3648,6 +3647,8 @@ cantfind_ext4:
>       goto failed_mount;
> 
> failed_mount4:
> +       iput(root);
> +       sb->s_root = NULL;
>       ext4_msg(sb, KERN_ERR, "mount failed");
>       destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
> failed_mount_wq:
> -- 
> 1.7.1
> 
> 
> 
>> 
>> Cheers, Andreas
>> 
>> On 2011-01-16, at 0:30, Manish Katiyar <mkatiyar@gmail.com> wrote:
>> 
>>> Fix missing iput for root inode in case of all failed mount paths.
>>> Fixes bug#26752
>>> 
>>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>>> 
>>> ---
>>> fs/ext4/super.c |    8 +++++++-
>>> 1 files changed, 7 insertions(+), 1 deletions(-)
>>> 
>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>> index cb10a06..9570fcc 100644
>>> --- a/fs/ext4/super.c
>>> +++ b/fs/ext4/super.c
>>> @@ -3587,6 +3587,7 @@ no_journal:
>>>       if (err) {
>>>               ext4_msg(sb, KERN_ERR, "failed to initialize system "
>>>                        "zone (%d)", err);
>>> +               iput(root);
>>>               goto failed_mount4;
>>>       }
>>> 
>>> @@ -3595,12 +3596,15 @@ no_journal:
>>>       if (err) {
>>>               ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
>>>                        err);
>>> +               iput(root);
>>>               goto failed_mount4;
>>>       }
>>> 
>>>       err = ext4_register_li_request(sb, first_not_zeroed);
>>> -       if (err)
>>> +       if (err) {
>>> +               iput(root);
>>>               goto failed_mount4;
>>> +       }
>>> 
>>>       sbi->s_kobj.kset = ext4_kset;
>>>       init_completion(&sbi->s_kobj_unregister);
>>> @@ -3609,6 +3613,7 @@ no_journal:
>>>       if (err) {
>>>               ext4_mb_release(sb);
>>>               ext4_ext_release(sb);
>>> +               iput(root);
>>>               goto failed_mount4;
>>>       };
>>> 
>>> @@ -3648,6 +3653,7 @@ cantfind_ext4:
>>>       goto failed_mount;
>>> 
>>> failed_mount4:
>>> +       sb->s_root = NULL;
>>>       ext4_msg(sb, KERN_ERR, "mount failed");
>>>       destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
>>> failed_mount_wq:
>>> --
>>> 1.7.1
>>> 
>>> 
>>> --
>>> Thanks -
>>> Manish
>>> ==================================
>>> [$\*.^ -- I miss being one of them
>>> ==================================
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> 
> 
> -- 
> Thanks -
> Manish
> ==================================
> [$\*.^ -- I miss being one of them
> ==================================


Cheers, Andreas





