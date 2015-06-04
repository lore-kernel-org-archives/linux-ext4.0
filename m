From: Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: Strange problems with lseek in qemu-img map
Date: Thu, 4 Jun 2015 11:52:02 +0800
Message-ID: <556FCB62.80200@cn.fujitsu.com>
References: <8145574.73ivEs6Dzv@o3-3>
	<20150603140607.GC20862@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, qemu-devel@nongnu.org
To: Stefan Hajnoczi <stefanha@gmail.com>, David Weber <wb@munzinger.de>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20150603140607.GC20862@stefanha-thinkpad.redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
List-Id: linux-ext4.vger.kernel.org

Cc: ext4 maillist

On 06/03/2015 10:06 PM, Stefan Hajnoczi wrote:
> On Tue, Jun 02, 2015 at 02:54:17PM +0200, David Weber wrote:
>> Testcase:
>> # qemu-img create test 500G
>> # time qemu-img map test
>>
>> Systems:
>> O3-3: Kubuntu 15.04 Workstation with stock-kernel 3.19.0-18-generic and stock 
>> qemu 2.2.0
>> Dinah: Ubuntu Server 15.04 with stock-kernel 3.19.0-18-generic and stock qemu 
>> 2.2.0
> 
> These systems have the same kernel but for some reason O3-3 completes
> quickly while Dinah takes a long time in lseek(fd, offset, SEEK_DATA).
> It looks like the file is empty (the syscall keeps returning ENXIO
> because there are no allocated blocks in the file where qemu-img
> probes).
> 
>> Result on O3-3:
>> root@o3-3:~# qemu-img create test 500G
>> Formatting 'test', fmt=raw size=536870912000 
>> root@o3-3:~# time qemu-img map test
>> Offset          Length          Mapped to       File
>>
>> real    0m0.049s
>> user    0m0.048s
>> sys     0m0.000s
>>
>> Result on dinah:
>> root@dinah:~# qemu-img create test 500G
>> Formatting 'test', fmt=raw size=536870912000 
>> root@dinah:~# time qemu-img map test
>> Offset          Length          Mapped to       File
>> ^C
>>
>> real    0m41.862s
>> user    0m0.004s
>> sys     0m0.068s
>> (Stopped with ^C)
>>
>> Strace on O3-3:
>> https://gist.github.com/anonymous/f221035e9176f7c71c74
>>
>> Strace on dinah:
>> https://gist.github.com/anonymous/40b42888a65478c90b32
>>
>> A git bisect between 1.7 and master revealed 
>> 7c15903789953ead14a417882657d52dc0c19a24 "block/raw-posix: use seek_hole ahead 
>> of fiemap" as bad but this is not the real problem.
>> I also tried to switch from btrfs to ext4 but it didn't change anything.
>>
>> At this point, I was pretty sure that was just stupit and missing something 
>> trivial.
>> I then startet a fedora 22 live system and I saw the same problem. It happens 
>> on both the ramdisk and a ext4 filesystem.
> 
> "it" == qemu-img map hangs or takes a very long time?
> 
> Can you post a shell script that reproduces this with a ramdisk?  That
> seems like the easiest way to get people debugging it.

I think it is ext4's problem. I add some printk in ext4_seek_data():
[  335.579506] ext4_seek_data(): isize: 7d00000000, offset: 0, maxsize: ffffffff000
[  335.579512] ext4_seek_data(): blkbits: 12, start: 0, end: 7d00000
[  340.672400] ext4_seek_data(): loop count: 131072001
[  340.672402] ext4_seek_data() returns -ENXIO
[  340.672447] ext4_seek_data(): isize: 7d00000000, offset: 40000000, maxsize: ffffffff000
[  340.672449] ext4_seek_data(): blkbits: 12, start: 40000, end: 7d00000
[  345.701852] ext4_seek_data(): loop count: 130809857
[  345.701853] ext4_seek_data() returns -ENXIO
[  345.701891] ext4_seek_data(): isize: 7d00000000, offset: 80000000, maxsize: ffffffff000
[  345.701893] ext4_seek_data(): blkbits: 12, start: 80000, end: 7d00000
[  350.718479] ext4_seek_data(): loop count: 130547713
[  350.718480] ext4_seek_data() returns -ENXIO
[  350.718507] ext4_seek_data(): isize: 7d00000000, offset: c0000000, maxsize: ffffffff000
[  350.718508] ext4_seek_data(): blkbits: 12, start: c0000, end: 7d00000
[  355.729692] ext4_seek_data(): loop count: 130285569
[  355.729693] ext4_seek_data() returns -ENXIO
[  355.729732] ext4_seek_data(): isize: 7d00000000, offset: 100000000, maxsize: ffffffff000
[  355.729734] ext4_seek_data(): blkbits: 12, start: 100000, end: 7d00000
[  360.728206] ext4_seek_data(): loop count: 130023425
[  360.728207] ext4_seek_data() returns -ENXIO

The diff:
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0613c25..9b334cc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -453,12 +453,16 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
        loff_t dataoff, isize;
        int blkbits;
        int ret = 0;
+       unsigned long count = 0;
 
        mutex_lock(&inode->i_mutex);
 
        isize = i_size_read(inode);
+       pr_info("%s(): isize: %llx, offset: %llx, maxsize: %llx\n",
+               __func__, isize, offset, maxsize);
        if (offset >= isize) {
                mutex_unlock(&inode->i_mutex);
+               pr_info("%s() returns -ENXIO(offset is too large)\n", __func__);
                return -ENXIO;
        }
 
@@ -467,8 +471,11 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
        last = start;
        end = isize >> blkbits;
        dataoff = offset;
+       pr_info("%s(): blkbits: %d, start: %x, end: %x\n",
+               __func__, blkbits, start, end);
 
        do {
+               count++;
                map.m_lblk = last;
                map.m_len = end - last + 1;
                ret = ext4_map_blocks(NULL, inode, &map, 0);
@@ -508,8 +515,12 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 
        mutex_unlock(&inode->i_mutex);
 
-       if (dataoff > isize)
+       pr_info("%s(): loop count: %ld\n", __func__, count);
+
+       if (dataoff > isize) {
+               pr_info("%s() returns -ENXIO\n", __func__);
                return -ENXIO;
+       }
 
        return vfs_setpos(file, dataoff, maxsize);
 }

We will call the syscall lseek(..., SEEK_DATA) 500 times.

Thanks
Wen Congyang

> 
> Stefan
> 
