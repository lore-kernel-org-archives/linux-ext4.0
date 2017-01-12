From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH v3 1/1] xfstests: generic/403: reproduce ext4 bugs in a
 shift extents logic
Date: Thu, 12 Jan 2017 09:02:25 +0100
Message-ID: <CAJrWOzDhdm1awxwrukzimxWGpXjD89T8fFGXabJYHvfEJEvxBQ@mail.gmail.com>
References: <20170111095239.18825-1-roman.penyaev@profitbricks.com> <20170112040820.GV1859@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34018 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdALICq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2017 03:02:46 -0500
Received: by mail-io0-f180.google.com with SMTP id l66so12703272ioi.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2017 00:02:46 -0800 (PST)
In-Reply-To: <20170112040820.GV1859@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2017 at 5:08 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Jan 11, 2017 at 10:52:39AM +0100, Roman Pen wrote:
>> Regression test which targets two nasty ext4 bugs in a logic which
>> shifts extents:
>>
>> 1) 14d981f468a1 ("ext4: Include forgotten start block on fallocate insert range")
>>
>> Test tries to insert many blocks at the same offset to reproduce
>> the following layout on ext4:
>>
>>    block #0  block #1
>>    |ext0 ext1|ext2 ext3 ...|
>>         ^
>>      insert of a new block
>>
>> Because of an incorrect range first block is never reached,
>> thus ext1 is untouched, resulting to a hole at a wrong offset:
>>
>> What we got:
>>
>>    block #0   block #1
>>    |ext0 ext1|   ext2 ext3 ...|
>>               ^
>>               hole at a wrong offset
>>
>> What we expect:
>>
>>    block #0    block #1
>>    |ext0   ext1|ext2 ext3 ...|
>>         ^
>>         hole at a correct offset
>>
>> 2) 2b3864b32403 ("ext4: do not polute the extents cache while shifting extents")
>>
>> Extents status tree is filled in with outdated offsets while doing
>> extent shift, that leads to wrong data blocks.   That's why md5sum
>> of a result file is being checked after each block insert.
>
> Thanks a lot! I did a minor update and queued it up.
>
>>
>> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
>> Cc: "Theodore Ts'o <tytso@mit.edu>"
>> Cc: Eryu Guan <eguan@redhat.com>
>> Cc: linux-ext4@vger.kernel.org
>> Cc: fstests@vger.kernel.org
>> ---
>
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_test
>> +_require_xfs_io_command "finsert"
>> +
>> +blksize=`get_block_size $TEST_DIR`
>
> I merged a patch earlier from Darrick to rename get_block_size to
> _get_block_size. So I did the rename here too.

Thanks.  The only thing which worries me is those commits references.
These patches are in Theodore's dev branch and I hope SHA1 wont be
changed.  Or maybe we have to postpone this new test till patches
appear in mainline.  I do not know.

--
Roman
