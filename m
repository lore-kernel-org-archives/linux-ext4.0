From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded call to ext4_es_remove_extent in
 punch hole
Date: Sat, 27 Apr 2013 12:20:22 +0530
Message-ID: <CAOiN93n2pM0d9O=wON=nAJNxj3T3XRBfpUk4SOvgg4=3NsvcYA@mail.gmail.com>
References: <1367037053-1893-1-git-send-email-ashish.sangwan2@gmail.com>
	<20130427052809.GA25185@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ashish Sangwan <ashishsangwan2@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	wenqing.lz@taobao.com, Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48243 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3D0GuX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Apr 2013 02:50:23 -0400
Received: by mail-qc0-f173.google.com with SMTP id b12so2430847qca.18
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 23:50:22 -0700 (PDT)
In-Reply-To: <20130427052809.GA25185@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 27, 2013 at 10:58 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Sat, Apr 27, 2013 at 10:00:53AM +0530, Ashish Sangwan wrote:
>> From: Ashish Sangwan <a.sangwan@samsung.com>
>>
>> During punch hole, before removing extents we make sure that the blocks
>> are commited to disk by calling filemap_write_and_wait_range. So, the
>> extents cannot be present on extent status tree.
>>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>
> Hi Ashish,
>
> I guess that this patch is against mainline kernel, right?
True

>The commit
> log is right before we use extent status tree to track all extent
> information.  In dev branch of ext4 tree, we track all extent status in
> status tree.  So we need to remove extent from status tree in punch
> hole.
I was of the opinion that filemap_write_and_wait_range will remove the
extent from status tree if its still there.
ok, I will check the dev branch.

Thanks,
Ashish
>
> Thanks,
>                                                 - Zheng
>
>> ---
>>  fs/ext4/inode.c |    7 -------
>>  1 files changed, 0 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 50cced9..944eb15 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3749,13 +3749,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>       down_write(&EXT4_I(inode)->i_data_sem);
>>       ext4_discard_preallocations(inode);
>>
>> -     ret = ext4_es_remove_extent(inode, first_block,
>> -                                 stop_block - first_block);
>> -     if (ret) {
>> -             up_write(&EXT4_I(inode)->i_data_sem);
>> -             goto out_stop;
>> -     }
>> -
>>       if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>>               ret = ext4_ext_remove_space(inode, first_block,
>>                                           stop_block - 1);
>> --
>> 1.7.8.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
