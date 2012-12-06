From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH, RFC] Ext4: Mount partition as read only if during orphan
 cleanup truncate fails to obtain journal handle.
Date: Thu, 6 Dec 2012 16:59:43 +0530
Message-ID: <CAOiN93nKkFAc_t6J+c1w4F3V-MYaq9cv2wfAq3hyniWz5wYFMw@mail.gmail.com>
References: <1351075240-2725-1-git-send-email-ashish.sangwan2@gmail.com>
	<CAKYAXd_6pHdPtOgOS4=_c6naWwPdMhna29OOKD919HrYM-+kaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	=?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57203 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423283Ab2LFL3o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2012 06:29:44 -0500
In-Reply-To: <CAKYAXd_6pHdPtOgOS4=_c6naWwPdMhna29OOKD919HrYM-+kaA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Did you get any time to look into this patch?
This problem is with ext4 only as ext4_truncate does not clean the
orphan list unlike that of ext3_truncate.
Instead, in case of failure to obtain handle, orphan list cleanup is
done in ext4_setattr.
But during mount, ext4_truncate is not called via ext4_setattr and
hence the problem.
What do you think?

On Fri, Oct 26, 2012 at 5:11 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> Add Cc in mail loop.
>
> Thanks.
>
> 2012/10/24, Ashish Sangwan <ashishsangwan2@gmail.com>:
>> During orphan cleanup while doing truncate, if we fail to obtain journal
>> handle, the inode for which truncate was called would not be removed from
>> both the on-disk and in-memory orphan lists as the call to ext4_orphan_del
>> would not be executed.
>>
>> This would have following consequences:
>> a) As the inode is not removed from the on-disk list, truncate would be
>> called again for the same inode. Each call would add the inode to the
>> in-memory list. This operation would continue endlessly or until truncate
>> is succeed.
>>
>> b) If somehow, after some iterations, truncate is succeed, ext4_orphan_del
>> will only remove the inode from in-memory list just 1 time. This will
>> trigger
>> j_assert during put super.
>>
>> This patch handles both the problems. If truncate fails, first in-memory
>> list is cleared and than the partition is mounted as read only.
>> Failure to obtain journal handle during mount may suggest that journal
>> device is corrupted.
>>
>> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  fs/ext4/super.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 4e2aacb..859eccb 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2201,7 +2201,21 @@ static void ext4_orphan_cleanup(struct super_block
>> *sb,
>>                       jbd_debug(2, "truncating inode %lu to %lld bytes\n",
>>                                 inode->i_ino, inode->i_size);
>>                       ext4_truncate(inode);
>> -                     nr_truncates++;
>> +                     if (list_empty(&EXT4_I(inode)->i_orphan)) {
>> +                             nr_truncates++;
>> +                     } else {
>> +                             /* Remove inode from in-memory orphan list */
>> +                             list_del_init(&EXT4_I(inode)->i_orphan);
>> +                             ext4_msg(sb, KERN_ERR, "Truncate failed for "
>> +                                      "orphan  inode = %lu. Running e2fsck"
>> +                                      " is recommended", inode->i_ino);
>> +                             if (!(s_flags & MS_RDONLY)) {
>> +                                     ext4_msg(sb, KERN_INFO, "FS would be"
>> +                                             " mounted as readonly");
>> +                                     s_flags |= MS_RDONLY;
>> +                             }
>> +                             break;
>> +                     }
>>               } else {
>>                       ext4_msg(sb, KERN_DEBUG,
>>                               "%s: deleting unreferenced inode %lu",
>> --
>> 1.7.11.4
>>
>>
