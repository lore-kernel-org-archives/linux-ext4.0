From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] ext4: add project quota mount options
Date: Fri, 8 Jul 2016 09:41:08 +0900
Message-ID: <CAP9B-QnWPTyWQp24VsefcjuXQcnFxt4HRoifomnUquJ3dkDUkw@mail.gmail.com>
References: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com> <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
	Wang Shilong <wshilong@ddn.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32982 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbcGHAlL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 20:41:11 -0400
Received: by mail-lf0-f67.google.com with SMTP id l188so2723257lfe.0
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2016 17:41:09 -0700 (PDT)
In-Reply-To: <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hell Eric,

On Fri, Jul 8, 2016 at 1:06 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 7/7/16 2:09 AM, Wang Shilong wrote:
>> From: Wang Shilong <wshilong@ddn.com>
>>
>> add prjquota, prjjquota, offprjjquota mount options
>> for project quota.
>>
>> These kind of mount options are used for old
>> quota design, and we can use quotas like these
>> way:
>>
>>  # mkfs.ext4 /dev/sda
>>  # mount /dev/sda -o prjquota /mnt/test
>>  # quotacheck -p /mnt/test
>>  # quotaon /mnt/test
>>
>> This new mount options are also useful to unify
>> some generic tests for xfs and ext4.
>
> Thanks, I definitely think this makes sense for symmetry, at least.
>
> The new mount options should also be documented in
> Documentation/filesystems/ext4.txt as well as the ext4(5) manpage
> in e2fsprogs.

Yes, i will add it.

>
> But speaking of documentation, is the whole "old vs new" quota
> behavior well-documented somewhere?  I'm afraid I've lost the
> thread on all that.  mount -o usrquota vs. mount -o usrjquota
> vs tune2fs vs mkfs vs. oh my!  ;)

This is my confusing before writting this patch.

Old quota design depends on mount options, and every mount
must follow same 'usrquota' etc mount options to make sure
space accounting is right.

I guess that is why new quota design is there, just enable
quota when mkfs, and space accounting will be enabled from then.
and we won't have to run 'quotacheck' to correct space accounting
hopely.

I don't know well what is usrjquota mean here too...maybe
Jan Kara have some ideas about that?


>
>> Signed-off-by: Wang Shilong <wshilong@ddn.com>
>> ---
>>  fs/ext4/ext4.h   |  1 +
>>  fs/ext4/ialloc.c |  4 ++--
>>  fs/ext4/inode.c  |  7 ++-----
>>  fs/ext4/ioctl.c  |  6 ++++--
>>  fs/ext4/super.c  | 43 +++++++++++++++++++++++++++++++++----------
>>  5 files changed, 42 insertions(+), 19 deletions(-)

<..snip..>


>>               return -EOPNOTSUPP;
>>       *projid = EXT4_I(inode)->i_projid;
>>       return 0;
>> @@ -4856,10 +4857,6 @@ static int ext4_do_update_inode(handle_t *handle,
>>               }
>>       }
>>
>> -     BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -                     EXT4_FEATURE_RO_COMPAT_PROJECT) &&
>> -            i_projid != EXT4_DEF_PROJID);
>> -
>
> Why was this removed vs. adding the mount option test?

As you can see with new mount options introduced, if next time
without prjquota mount options, some existed inode projid is
still none zero, so this assumptions will be wrong.



>
>>       if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
>>           EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
>>               raw_inode->i_projid = cpu_to_le32(i_projid);
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index b5a39b0..6062a81 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -311,7 +311,8 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>>       struct dquot *transfer_to[MAXQUOTAS] = { };
>>
>>       if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -                     EXT4_FEATURE_RO_COMPAT_PROJECT)) {
>> +                     EXT4_FEATURE_RO_COMPAT_PROJECT) &&
>> +         !test_opt(sb, PRJQUOTA)) {
>>               if (projid != EXT4_DEF_PROJID)
>>                       return -EOPNOTSUPP;
>>               else
