From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v1 4/4] Add inherit flags for project quota
Date: Tue, 5 Jan 2016 21:01:21 +0800
Message-ID: <CAPTn0cA2ZTQf_dYjpzaQJ-=4V8X-t8sa7XMHuxQaE1HADg9uDQ@mail.gmail.com>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com>
	<1446046933-26571-5-git-send-email-lixi@ddn.com>
	<0B73D69E-7BA4-47AE-8094-C9AB78AED569@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:36728 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbcAENBW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jan 2016 08:01:22 -0500
Received: by mail-vk0-f68.google.com with SMTP id a185so19360609vkb.3
        for <linux-ext4@vger.kernel.org>; Tue, 05 Jan 2016 05:01:21 -0800 (PST)
In-Reply-To: <0B73D69E-7BA4-47AE-8094-C9AB78AED569@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Agreed. I makes sense to include it into e2fsprogs, thus chattr and lsattr.
It seems better to require e2fsprogs installed rather than xfsprogs when using
a feature of ext4.

Currently, I am using a independent tool to set and get project ID. And that
tool call IOCTL of EXT4_IOC_FSSETXATTR and EXT4_IOC_FSGETXATTR.

On Sat, Dec 12, 2015 at 7:13 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Oct 28, 2015, at 9:42 AM, Li Xi <pkuelelixi@gmail.com> wrote:
>>
>> This patch add EXT4_PROJINHERIT_FL to enable inherit feature
>> for project quota.
>>
>> Signed-off-by: Li Xi <lixi@ddn.com>
>> Change-Id: I61491333eabcc33ccc09fa1ed5f8ffe4c4220e57
>> ---
>> lib/e2p/pf.c         |    1 +
>> lib/ext2fs/ext2_fs.h |    5 +++--
>> misc/chattr.c        |    3 ++-
>> 3 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
>> index 8961727..27421a6 100644
>> --- a/lib/e2p/pf.c
>> +++ b/lib/e2p/pf.c
>> @@ -46,6 +46,7 @@ static struct flags_name flags_array[] = {
>>       { EXT4_HUGE_FILE_FL, "h", "Huge_file" },
>>       { FS_NOCOW_FL, "C", "No_COW" },
>>       { EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
>> +     { EXT4_PROJINHERIT_FL, "P", "Project_Iherit" },
>>       { 0, NULL, NULL }
>> };
>>
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 036e6ad..4e46f22 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -327,10 +327,11 @@ struct ext2_dx_tail {
>> #define EXT4_SNAPFILE_DELETED_FL      0x04000000  /* Snapshot is being deleted */
>> #define EXT4_SNAPFILE_SHRUNK_FL               0x08000000  /* Snapshot shrink has completed */
>> #define EXT4_INLINE_DATA_FL           0x10000000 /* Inode has inline data */
>> +#define EXT4_PROJINHERIT_FL          0x20000000 /* Create with parents projid */
>> #define EXT2_RESERVED_FL              0x80000000 /* reserved for ext2 lib */
>>
>> -#define EXT2_FL_USER_VISIBLE         0x004BDFFF /* User visible flags */
>> -#define EXT2_FL_USER_MODIFIABLE              0x004B80FF /* User modifiable flags */
>> +#define EXT2_FL_USER_VISIBLE         0x204BDFFF /* User visible flags */
>> +#define EXT2_FL_USER_MODIFIABLE              0x204B80FF /* User modifiable flags */
>>
>> /*
>>  * ioctl commands
>> diff --git a/misc/chattr.c b/misc/chattr.c
>> index e55d693..40069c9 100644
>> --- a/misc/chattr.c
>> +++ b/misc/chattr.c
>> @@ -83,7 +83,7 @@ static unsigned long sf;
>> static void usage(void)
>> {
>>       fprintf(stderr,
>> -             _("Usage: %s [-RVf] [-+=aAcCdDeijsStTu] [-v version] files...\n"),
>> +             _("Usage: %s [-RVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
>>               program_name);
>>       exit(1);
>> }
>> @@ -103,6 +103,7 @@ static const struct flags_char flags_array[] = {
>>       { EXT4_EXTENTS_FL, 'e'},
>>       { EXT2_IMMUTABLE_FL, 'i' },
>>       { EXT3_JOURNAL_DATA_FL, 'j' },
>> +     { EXT4_PROJINHERIT_FL, 'P' },
>>       { EXT2_SECRM_FL, 's' },
>>       { EXT2_UNRM_FL, 'u' },
>>       { EXT2_NOTAIL_FL, 't' },
>
> How does one set the actual project ID on an inode?  I'd have thought that
> "chattr" and "lsattr -P" could change and list the project ID on an inode,
> since regular "stat" and "ls" will not do this today.  I don't think it is OK
> to require xfsprogs to be installed to be able to set these fields, though
> chattr and lsattr should use the same ioctl() values FS_IOC_FSSETXATTR and
> FS_IOC_FSGETXATTR as the xfsprogs utils do.
>
> Cheers, Andreas
>
>
>
>
>
