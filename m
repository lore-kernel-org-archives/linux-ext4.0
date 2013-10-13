From: baixing quan <quanbaixin@gmail.com>
Subject: Re: [PATCH]An inlinedata bug in ext4_destroy_inline_data_nolock()
Date: Sun, 13 Oct 2013 21:15:26 +0800
Message-ID: <CACKVGOYWmVu0s0D1ZNxCERmOGSUGiUVUT2AVWNKUfNE7bwKpiw@mail.gmail.com>
References: <CACKVGOZQn1S3nrF_p7sNnV8Z0Y--dnLFgt5P4TB56DP_yB0_-A@mail.gmail.com>
	<5254D733.6010609@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41018 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3JMNP2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Oct 2013 09:15:28 -0400
Received: by mail-wg0-f46.google.com with SMTP id k14so6264734wgh.1
        for <linux-ext4@vger.kernel.org>; Sun, 13 Oct 2013 06:15:27 -0700 (PDT)
In-Reply-To: <5254D733.6010609@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Baixing Quan <quabaixin@gmai.com>
---
 fs/ext4/inline.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d9ecbf1..cc6375e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -434,6 +434,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,

        memset((void *)ext4_raw_inode(&is.iloc)->i_block,
                0, EXT4_MIN_INLINE_DATA_SIZE);
+       memset(ei->i_data, 0, sizeof(ei->i_data));

        if (EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
                                      EXT4_FEATURE_INCOMPAT_EXTENTS)) {
-- 
1.7.9.4

2013/10/9 Tao Ma <tm@tao.ma>:
> On 10/08/2013 11:32 PM, baixing quan wrote:
>> Filesystem with inlinedata will be remounted with read only mode as
>> follow steps:
>>
>> 1.mkdir tmp
>> 2.cd tmp
>> 3.mkdir a12345 a23456 a34567 a45678 a67890 a78901
>> 4.reboot
>> 5.cd tmp
>> 6.mv a23456 a23456aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
>>
>> The bug happened in ext4_rename()
>> 3122         if (le32_to_cpu(old_de->inode) != old_inode->i_ino ||
>> 3123             old_de->name_len != old_dentry->d_name.len ||
>> 3124             strncmp(old_de->name, old_dentry->d_name.name,
>> old_de->name_len) ||
>> 3125             (retval = ext4_delete_entry(handle, old_dir,
>> 3126                                         old_de, old_bh)) == -ENOENT)
>>
>> ext4_delete_entry-> ext4_generic_delete_entry-> ext4_check_dir_entry()
>>  find the inode number is illegal and the system is remounted with
>> read only mode.
>>
>> When the inlinedata is cleared in
>> ext4_destroy_inline_data_nolock(),ext4_inode->i_block[] is set to 0,
>> but ext4_inode->i_block[] is assigned as ext4_inode_info->i_block[] in
>> ext4_mark_iloc_dirty().Therefore, the inlinedata still exist in
>> ext4_inode->i_block[] and result in ext4_delete_entry() in line 3125
>> is executed.
> oh, thanks for the detailed explanation, soo the patch looks good to me.
> But would you mind try what Darrick suggest? A good reference book
> should be Documentation/SubmittingPatches.
>
> Thanks,
> Tao
>>
>>
>> From d0e24fc2c0817fafe816b510060c711e56b6b645 Mon Sep 17 00:00:00 2001
>> From: qbx <quanbaixin@126.com>
>> Date: Tue, 8 Oct 2013 07:04:13 -0700
>> Subject: [PATCH] inlinedata rename bug
>>
>> ---
>>  fs/ext4/inline.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index d9ecbf1..cc6375e 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
>> @@ -434,6 +434,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
>>
>>         memset((void *)ext4_raw_inode(&is.iloc)->i_block,
>>                 0, EXT4_MIN_INLINE_DATA_SIZE);
>> +       memset(ei->i_data,0, sizeof(ei->i_data));
>>
>>         if (EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
>>                                       EXT4_FEATURE_INCOMPAT_EXTENTS)) {
>>
>
