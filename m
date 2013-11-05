From: Andiry Xu <andiry@gmail.com>
Subject: Re: [BUG][ext2] XIP does not work on ext2
Date: Mon, 4 Nov 2013 18:37:40 -0800
Message-ID: <CAOvWMLZ6_boRgQi2L9kqR_bWcnLDHY+uFo9g4DP=zxeGtT+dag@mail.gmail.com>
References: <CAOvWMLZ-ezykR6TkFAoZ1UW20QF6XMOKeZH8R-FdFJkXjAP9nA@mail.gmail.com>
	<20131105003733.GA24531@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andiry Xu <andiry.xu@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131105003733.GA24531@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

On Mon, Nov 4, 2013 at 4:37 PM, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> On Mon 04-11-13 14:31:34, Andiry Xu wrote:
>> When I'm trying XIP on ext2, I find that xip does not work on ext2
>> with latest kernel.
>>
>> Reproduce steps:
>> Compile kernel with following configs:
>> CONFIG_BLK_DEV_XIP=y
>> CONFIG_EXT2_FS_XIP=y
>>
>> And run following commands:
>> # mke2fs -b 4096 /dev/ram0
>> # mount -t ext2 -o xip /dev/ram0 /mnt/ramdisk/
>> # dd if=/dev/zero of=/mnt/ramdisk/test1 bs=1M count=16
>>
>> And it shows:
>> dd: writing `/mnt/ramdisk/test1': No space left on device
>>
>> df also shows /mnt/ramdisk is 100% full. Its default size is 64MB so a
>> 16MB write should only occupy 1/4 capacity.
>>
>> Criminal commit:
>> After git bisect, it points to the following commit:
>> 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b
>> Ext2: mark inode dirty after the function dquot_free_block_nodirty is called
>   Thanks for report and the bisection!
>
>> Particularly, the following code:
>> @@ -1412,9 +1415,11 @@ allocated:
>> *errp = 0;
>> brelse(bitmap_bh);
>> -    dquot_free_block_nodirty(inode, *count-num);
>> -    mark_inode_dirty(inode);
>> -    *count = num;
>> +    if (num < *count) {
>> +        dquot_free_block_nodirty(inode, *count-num);
>> +        mark_inode_dirty(inode);
>> +        *count = num;
>> +    }
>>       return ret_block;
>>
>> Not mark_inode_dirty() is called only when num is less than *count.
>> However, I've seen
>> with the dd command, there is case where num >= *count.
>>
>> Fix:
>> I've verified that the following patch fixes the issue:
>> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
>> index 9f9992b..5446a52 100644
>> --- a/fs/ext2/balloc.c
>> +++ b/fs/ext2/balloc.c
>> @@ -1406,11 +1406,10 @@ allocated:
>>
>>         *errp = 0;
>>         brelse(bitmap_bh);
>> -       if (num < *count) {
>> +       if (num <= *count)
>>                 dquot_free_block_nodirty(inode, *count-num);
>> -               mark_inode_dirty(inode);
>> -               *count = num;
>> -       }
>> +       mark_inode_dirty(inode);
>> +       *count = num;
>>         return ret_block;
>>
>>  io_error:
>>
>> However, I'm not familiar with ext2 source code and cannot tell if
>> this is the correct fix. At least it fixes my issue.
>   With this, you have essentially reverted a hunk from commit
> 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b. But I don't see a reason why it
> should be reverted. num should never ever be greater than *count and when
> num == count, we the code inside if doesn't do anything useful.
>
> I've looked into the code and I think I see the problem. It is a long
> standing bug in __ext2_get_block() in fs/ext2/xip.c. It calls
> ext2_get_block() asking for 0 blocks to map (while we really want 1 block).
> ext2_get_block() just passes that request and ext2_get_blocks() actually
> allocates 1 block. And that's were the commit you have identified makes a
> difference because previously we returned that 1 block was allocated while
> now we return that 0 blocks were allocated and thus allocation is repeated
> until all free blocks are exhaused.
>
> Attached patch should fix the problem.
>

Thanks for the reply. I've verified that your patch fixes my issue.
And it's absolutely better than my solution.

Tested-by: Andiry Xu <andiry.xu@gmail.com>

I have another question about ext2 XIP performance, although it's not
quite related to this thread.

I'm testing xip with ext2 on a ram disk drive, the driver is brd.c.
The RAM disk size is 2GB and I pre-fill it to guarantee that all pages
reside in main memory.
Then I use two different applications to write to the ram disk. One is
open() with O_DIRECT flag, and writing with Posix write(). Another is
open() with O_DIRECT, mmap() it to user space, then use memcpy() to
write data. I use different request size to write data, from 512 bytes
to 64MB.

In my understanding, the mmap version bypasses the file system and
does not go to kernel space, hence it should have better performance
than the Posix-write version. However, my test result shows it's not
always true: when the request size is between 8KB and 1MB, the
Posix-write() version has bandwidth about 7GB/s and mmap version only
has 5GB/s. The test is performed on a i7-3770K machine with 8GB
memory, kernel 3.12. Also I have tested on kernel 3.2, in which mmap
has really bad performance, only 2GB/s for all request sizes.

Do you know the reason why write() outperforms mmap() in some cases? I
know it's not related the thread but I really appreciate if you can
answer my question.

Thanks,
Andiry
