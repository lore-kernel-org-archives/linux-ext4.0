From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v8 0/5] ext4: add project quota support
Date: Fri, 13 Feb 2015 10:00:27 +0800
Message-ID: <CAPTn0cCwm2HGLZVf-FqpNNPEM=nVBNeTcE6BV6xbnNa_XOuZtw@mail.gmail.com>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
	<CAGW2f1EX7TW=yKhwWD5HHfKz-U5GEnnzHO0fN5MLd5Cr4no1wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34447 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbBMCA2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2015 21:00:28 -0500
Received: by mail-pa0-f49.google.com with SMTP id fb1so15398480pad.8
        for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2015 18:00:28 -0800 (PST)
In-Reply-To: <CAGW2f1EX7TW=yKhwWD5HHfKz-U5GEnnzHO0fN5MLd5Cr4no1wQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jon,

Yeah, I've written a script to test the project quota which has about
a dozen of test suites. However, sorry, I didn't add xfstest cases for
it. And we need to apply a series of e2fsprogs patches to enable
project quota feature though.

Thanks,
Li Xi

On Tue, Jan 27, 2015 at 2:46 AM, jon ernst <jonernst07@gmail.com> wrote:
> Xi,
> Just a question, do you have any test scripts or xfstest cases for
> this patchset?
>
> Thanks,
> Jon
>
> On Tue, Dec 9, 2014 at 12:22 AM, Li Xi <pkuelelixi@gmail.com> wrote:
>> The following patches propose an implementation of project quota
>> support for ext4. A project is an aggregate of unrelated inodes
>> which might scatter in different directories. Inodes that belong
>> to the same project possess an identical identification i.e.
>> 'project ID', just like every inode has its user/group
>> identification. The following patches add project quota as
>> supplement to the former uer/group quota types.
>>
>> The semantics of ext4 project quota is consistent with XFS. Each
>> directory can have EXT4_INODE_PROJINHERIT flag set. When the
>> EXT4_INODE_PROJINHERIT flag of a parent directory is not set, a
>> newly created inode under that directory will have a default project
>> ID (i.e. 0). And its EXT4_INODE_PROJINHERIT flag is not set either.
>> When this flag is set on a directory, following rules will be kept:
>>
>> 1) The newly created inode under that directory will inherit both
>> the EXT4_INODE_PROJINHERIT flag and the project ID from its parent
>> directory.
>>
>> 2) Hard-linking a inode with different project ID into that directory
>> will fail with errno EXDEV.
>>
>> 3) Renaming a inode with different project ID into that directory
>> will fail with errno EXDEV. However, 'mv' command will detect this
>> failure and copy the renamed inode to a new inode in the directory.
>> Thus, this new inode will inherit both the project ID and
>> EXT4_INODE_PROJINHERIT flag.
>>
>> 4) If the project quota of that ID is being enforced, statfs() on
>> that directory will take the quotas as another upper limits along
>> with the capacity of the file system, i.e. the total block/inode
>> number will be the minimum of the quota limits and file system
>> capacity.
>>
>> Changelog:
>> * v8 <- v7:
>>  - Rebase to newest dev branch of ext4 repository (3.18.0_rc3).
>> * v7 <- v6:
>>  - Map ext4 inode flags to xflags of struct fsxattr;
>>  - Add patch to cleanup ext4 inode flag definitions.
>> * v6 <- v5:
>>  - Add project ID check for cross rename;
>>  - Remove patch of EXT4_IOC_GETPROJECT/EXT4_IOC_SETPROJECT ioctl
>> * v5 <- v4:
>>  - Check project feature when set/get project ID;
>>  - Do not check project feature for project quota;
>>  - Add support of FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR.
>> * v4 <- v3:
>>  - Do not check project feature when set/get project ID;
>>  - Use EXT4_MAXQUOTAS instead of MAXQUOTAS in ext4 patches;
>>  - Remove unnecessary change of fs/quota/dquot.c;
>>  - Remove CONFIG_QUOTA_PROJECT.
>> * v3 <- v2:
>>  - Add EXT4_INODE_PROJINHERIT semantics.
>> * v2 <- v1:
>>  - Add ioctl interface for setting/getting project;
>>  - Add EXT4_FEATURE_RO_COMPAT_PROJECT;
>>  - Add get_projid() method in struct dquot_operations;
>>  - Add error check of ext4_inode_projid_set/get().
>>
>> v7: http://www.spinics.net/lists/linux-fsdevel/msg80404.html
>> v6: http://www.spinics.net/lists/linux-fsdevel/msg80022.html
>> v5: http://www.spinics.net/lists/linux-api/msg04840.html
>> v4: http://lwn.net/Articles/612972/
>> v3: http://www.spinics.net/lists/linux-ext4/msg45184.html
>> v2: http://www.spinics.net/lists/linux-ext4/msg44695.html
>> v1: http://article.gmane.org/gmane.comp.file-systems.ext4/45153
>>
>> Any comments or feedbacks are appreciated.
>>
>> Regards,
>>                                          - Li Xi
>>
>> Li Xi (5):
>>   vfs: adds general codes to enforces project quota limits
>>   ext4: adds project ID support
>>   ext4: adds project quota support
>>   ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
>>   ext4: cleanup inode flag definitions
>>
>>  fs/ext4/ext4.h             |  190 +++++++++++++++++++++----
>>  fs/ext4/ialloc.c           |    6 +
>>  fs/ext4/inode.c            |   29 ++++
>>  fs/ext4/ioctl.c            |  330 +++++++++++++++++++++++++++++++-------------
>>  fs/ext4/namei.c            |   17 +++
>>  fs/ext4/super.c            |   96 +++++++++++--
>>  fs/quota/dquot.c           |   35 ++++-
>>  fs/quota/quota.c           |    8 +-
>>  fs/quota/quotaio_v2.h      |    6 +-
>>  fs/xfs/xfs_fs.h            |   47 +++----
>>  include/linux/quota.h      |    2 +
>>  include/uapi/linux/fs.h    |   59 ++++++++
>>  include/uapi/linux/quota.h |    6 +-
>>  13 files changed, 650 insertions(+), 181 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
