From: Cuong Tran <cuonghuutran@gmail.com>
Subject: Re: Java Stop-the-World GC stall induced by FS flush or many large
 file deletions
Date: Thu, 12 Sep 2013 04:46:59 -0700
Message-ID: <CALQm4jj7FG+nYe=5uL_ERSfk7Nkd98cxuF_c0guu0mV8aw3WVg@mail.gmail.com>
References: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
 <20130912074618.GA13357@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Cuong Tran <cuonghuutran@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130912074618.GA13357@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Zheng, this is output of tune2fs:
tune2fs 1.41.12 (17-May-2010)
Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          358707f1-8997-4e96-8110-d9f929073e68
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    journal_data_writeback user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              23281664
Block count:              93110272
Reserved block count:     4655513
Free blocks:              44878839
Free inodes:              22074662
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1001
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Oct  7 05:01:07 2011
Last mount time:          Mon Sep  9 18:49:39 2013
Last write time:          Wed Aug 21 10:48:03 2013
Mount count:              23
Maximum mount count:      -1
Last checked:             Fri Oct  7 05:01:07 2011
Check interval:           0 (<none>)
Lifetime writes:          1795 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       4207998
Default directory hash:   half_md4
Directory Hash Seed:      4de319c2-fc2d-4771-b4de-b63acd610ba0
Journal backup:           inode blocks

And this is mount options:
UUID=358707f1-8997-4e96-8110-d9f929073e68 /                       ext4
   defaults        1 1


Yes, I forgot to mention that in the deferred write test, turning off
deferred allocation or using preallocation, the problem is largely
gone. I mentioned largely gone because it still happens but much less
frequently.

Thanks.

--Cuong

On Thu, Sep 12, 2013 at 12:46 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hello Cuong,
>
> Could you please tell us the kernel version?  Meanwhile it would be
> better if you could paste the result of the following commands:
>  * sudo tune2fs -l ${DEV}
>  * cat /proc/mounts | grep ${DEV}
>
> I want to know which feature is enabled in your file system.  From your
> description, I guess delayed allocation is enabled.  So I suggest that
> you can try to disable it.  You can disable it using the following
> command:
>  * sudo mount -t ext4 -o remount,nodelalloc ${DEV} ${MNT}
>
> Regards,
>                                                 - Zheng
>
> On Wed, Sep 11, 2013 at 09:17:26PM -0700, Cuong Tran wrote:
>> We have seen GC stalls that are NOT due to memory usage of applications.
>>
>> GC log reports the CPU user and system time of GC threads, which are
>> almost 0, and stop-the-world time, which can be multiple seconds. This
>> indicates GC threads are waiting for IO but GC threads should be
>> CPU-bound in user mode.
>>
>> We could reproduce the problems using a simple Java program that just
>> appends to a log file via log4j. If the test just runs by itself, it
>> does not incur any GC stalls. However, if we run a script that enters
>> a loop to create multiple large file via falloc() and then deletes
>> them, then GC stall of 1+ seconds can happen fairly predictably.
>>
>> We can also reproduce the problem by periodically switch the log and
>> gzip the older log. IO device, a single disk drive, is overloaded by
>> FS flush when this happens.
>>
>> Our guess is GC has to acquiesce its threads and if one of the threads
>> is stuck in the kernel (say in non-interruptible mode). Then GC has to
>> wait until this thread unblocks. In the mean time, it already stops
>> the world.
>>
>> Another test that shows similar problem is doing deferred writes to
>> append a file. Latency of deferred writes is very fast but once a
>> while, it can last more than 1 second.
>>
>> We would really appreciate if you could shed some light on possible
>> causes? (Threads blocked because of journal check point, delayed
>> allocation can't proceed?). We could alleviate the problem by
>> configuring expire_centisecs and writeback_centisecs to flush more
>> frequently, and thus even-out the workload to the disk drive. But we
>> would like to know if there  is a methodology to model the rate of
>> flush vs. rate of changes and IO throughput of the drive (SAS, 15K
>> RPM).
>>
>> Many thanks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
