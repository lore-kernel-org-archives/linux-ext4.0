From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: mmc filesystem performance decreased on the first write after
 filesystem creation
Date: Wed, 30 May 2018 11:51:41 +0300
Message-ID: <43d4164f-5dda-b49a-6008-1f5bf4b08547@intel.com>
References: <a976e20a-3ed1-43d0-4665-f570ef496d02@ti.com>
 <20180528062618.GA4196@lst.de>
 <c6a47e30-f07d-3f79-2189-38b6f01429b9@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, linux-ext4@vger.kernel.org,
        tytso@mit.edu
To: Christoph Hellwig <hch@lst.de>, Faiz Abbas <faiz_abbas@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c6a47e30-f07d-3f79-2189-38b6f01429b9@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 30/05/18 11:44, Adrian Hunter wrote:
> On 28/05/18 09:26, Christoph Hellwig wrote:
>> Summary: mke2s uses the BLKDISCARD ioctl to wipe the device,
>> and then uses BLKDISCARDZEROES to check if that zeroed the data.
>>
>> A while ago I made BLKDISCARDZEROES always return 0 because it is
>> basically impossible to have reliably zeroing using discard as the
>> standards leave the devices way to many options to not actually
>> zero data at their own choice when using the discard commands.
> 
> Older eMMC do not have a "discard" option and use "erase" instead.  "Erase"
> has similar benefits to "discard" but the eMMC is required to make the
> erased blocks read as either all 0's or all 1's.
> 
>>
>> So IFF mke2fs want to actually free space and zero it it needs
>> to use fallocate to punch a hole, and mmc needs to implement
>> REQ_OP_WRITE_ZEROS IFF it actually has a reliable way to zero
>> blocks.
>>
>>
>> On Tue, May 22, 2018 at 08:48:31PM +0530, Faiz Abbas wrote:
>>> Hi,
>>>
>>> I am debugging a performance reduction in ext2 filesystems on an mmc
>>> device in TI's am335x evm board.
>>>
>>> I see that the performance is reduced on the first write after making a
>>> new filesystem using mkfs.ext2 on one of the mmc partitions. The
>>> performance comes back to normal after the first write.
>>>
>>> commands used:
>>>
>>> => umount /dev/mmcblk1p2
>>>
>>> => mkfs.ext2 -F  /dev/mmcblk1p2
>>>
>>> => mount -t ext2 -o async /dev/mmcblk1p2 /mnt/partition_mmc
>>>
>>> => dd if=/dev/urandom of=/dev/shm/srctest_file_mmc_1184 bs=1M count=10
>>>
>>> => ./filesystem_tests -write -src_file /dev/shm/srctest_file_mmc_1184
>>> -srcfile_size 10 -file /mnt/partition_mmc/test_file_1184 -buffer_size
>>> 102400 -file_size 100 -performance
>>>
>>> The filesystem_tests write utility reads from the file generated at
>>> /dev/shm/srctest_file_mmc_1184, memory maps the file to a buffer, and
>>> then writes it into the newly created /mnt/partition_mmc in multiples of
>>> buffer_size while measuring write performance.
>>>
>>> See here for the implementation of filesystem_tests write utility:
>>> http://arago-project.org/git/projects/?p=test-automation/ltp-ddt.git;a=blob;f=testcases/ddt/filesystem_test_suite/src/testcases/st_filesystem_write_to_file.c;h=80e8e244d7eaa9f0dbd9b21ea705445156c36bef;hb=f7fc06c290333ce08a7d4fba104eee0f0f1d942b
>>>
>>> Complete log with multiple calls to filesystem_tests:
>>> https://pastebin.ubuntu.com/p/BckmTJpqPv/
>>>
>>> Notice that the first run of filesystem_tests has a lower throughput
>>> reported.
>>>
>>> I was able to bisect the issue to this commit:
>>> 5d1429fead5b (mmc: remove the discard_zeroes_data flag)
>>>
>>> I would assume that after this flag is removed, the filesystem creation
>>> command would explicitly write zeroes to the device which might explain
>>> the performance fall. However, then the mkfs.ext2 command itself should
>>> take more time rather than the first file write after that.
> 
> You might want to check the lazy initialization options.  I always use
> "-Elazy_itable_init=0,lazy_journal_init=0" with ext4 to prevent it messing
> up performance tests.

And discards are not enabled by default by mount so, at least on ext4,
adding "-o discard" is needed in the mount options.
