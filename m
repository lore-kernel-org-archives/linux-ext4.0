From: Kit Westneat <kwestneat@ddn.com>
Subject: Re: [PATCH] e2image: double free when restoring image
Date: Mon, 2 Dec 2013 12:27:03 -0500
Message-ID: <529CC2E7.90806@ddn.com>
References: <529664F6.3040103@ddn.com> <2536F444-3B5C-4A73-94A1-9464F89B29CD@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:28823 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab3LBR1K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 12:27:10 -0500
In-Reply-To: <2536F444-3B5C-4A73-94A1-9464F89B29CD@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs: copy fs block size to new io

e2image manually opens a new IO channel, which uses the default block
size of 1k. This patch sets the new IO channel's block size to match the
fs block size.

Signed-off-by: Kit Westneat <kwestneat@ddn.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
---

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 113b80e..6861cfe 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -441,6 +441,7 @@ errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, 
io_channel new_io)
  {
  	if ((fs->flags & EXT2_FLAG_IMAGE_FILE) == 0)
  		return EXT2_ET_NOT_IMAGE_FILE;
+	new_io->block_size = fs->io->block_size;
  	fs->io = fs->image_io = new_io;
  	fs->flags |= EXT2_FLAG_DIRTY | EXT2_FLAG_RW |
  		EXT2_FLAG_BB_DIRTY | EXT2_FLAG_IB_DIRTY;

---
Kit Westneat
L3 Lustre Support, DDN
703-659-3869

On 11/29/2013 12:45 PM, Dilger, Andreas wrote:
> Kit, thanks for sending the patch to the list.
>
> You'll need to add a Signed-off-by: line. You can also add Reviewed-by: from me as well.
>
> Cheers, Andreas
>
> On 2013-11-27, at 14:33, "Kit Westneat" <kwestneat@ddn.com> wrote:
>
>> Hello,
>>
>> I've been running into a double free when trying to apply an e2image to a
>> loopback device:
>>
>> # e2image /dev/sda1 sda1.img
>> e2image 1.43-WIP (8-Jul-2013)
>> # dd if=/dev/zero of=./lofile bs=1M seek=1k count=1
>> 1+0 records in
>> 1+0 records out
>> 1048576 bytes (1.0 MB) copied, 0.00131481 s, 798 MB/s
>> # losetup /dev/loop0 ./lofile
>> # e2image -I /dev/loop0 ./sda1.img
>> e2image 1.43-WIP (8-Jul-2013)
>> *** glibc detected *** e2image: double free or corruption (!prev): 0x00000000011c3fd0 ***
>> ======= Backtrace: =========
>> /lib64/libc.so.6(+0x75296)[0x7f107bf62296]
>> e2image[0x4125ab]
>> e2image[0x408674]
>> e2image[0x40448c]
>> /lib64/libc.so.6(__libc_start_main+0xfd)[0x7f107bf0bcdd]
>> e2image[0x401ce9]
>> ======= Memory map: ========
>> 00400000-00425000 r-xp 00000000 fd:00 8907                               /sbin/e2image
>> 00625000-00626000 rw-p 00025000 fd:00 8907                               /sbin/e2image
>> 011b1000-011f3000 rw-p 00000000 00:00 0                                  [heap]
>> 7f1075e46000-7f1075e5c000 r-xp 00000000 fd:00 50                         /lib64/libgcc_s-4.4.6-20110824.so.1
>> 7f1075e5c000-7f107605b000 ---p 00016000 fd:00 50                         /lib64/libgcc_s-4.4.6-20110824.so.1
>> 7f107605b000-7f107605c000 rw-p 00015000 fd:00 50                         /lib64/libgcc_s-4.4.6-20110824.so.1
>> 7f107605c000-7f107beed000 r--p 00000000 fd:00 3172                       /usr/lib/locale/locale-archive
>> 7f107beed000-7f107c073000 r-xp 00000000 fd:00 3189                       /lib64/libc-2.12.so
>> 7f107c073000-7f107c273000 ---p 00186000 fd:00 3189                       /lib64/libc-2.12.so
>> 7f107c273000-7f107c277000 r--p 00186000 fd:00 3189                       /lib64/libc-2.12.so
>> 7f107c277000-7f107c278000 rw-p 0018a000 fd:00 3189                       /lib64/libc-2.12.so
>> 7f107c278000-7f107c27d000 rw-p 00000000 00:00 0
>> 7f107c27d000-7f107c294000 r-xp 00000000 fd:00 3213                       /lib64/libpthread-2.12.so
>> 7f107c294000-7f107c493000 ---p 00017000 fd:00 3213                       /lib64/libpthread-2.12.so
>> 7f107c493000-7f107c494000 r--p 00016000 fd:00 3213                       /lib64/libpthread-2.12.so
>> 7f107c494000-7f107c495000 rw-p 00017000 fd:00 3213                       /lib64/libpthread-2.12.so
>> 7f107c495000-7f107c499000 rw-p 00000000 00:00 0
>> 7f107c499000-7f107c4b9000 r-xp 00000000 fd:00 3182                       /lib64/ld-2.12.so
>> 7f107c6ad000-7f107c6b0000 rw-p 00000000 00:00 0
>> 7f107c6b6000-7f107c6b8000 rw-p 00000000 00:00 0
>> 7f107c6b8000-7f107c6b9000 r--p 0001f000 fd:00 3182                       /lib64/ld-2.12.so
>> 7f107c6b9000-7f107c6ba000 rw-p 00020000 fd:00 3182                       /lib64/ld-2.12.so
>> 7f107c6ba000-7f107c6bb000 rw-p 00000000 00:00 0
>> 7fffa93b9000-7fffa93ce000 rw-p 00000000 00:00 0                          [stack]
>> 7fffa93ff000-7fffa9400000 r-xp 00000000 00:00 0                          [vdso]
>> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
>> Aborted
>>
>> It appears to be due to a mismatch between the IO channel block size and the FS
>> block size. ext2fs_rewrite_to_io is resetting the fs->io to be the IO channel of
>> the new device, but that device still has the default unix IO channel block size
>> of 1k. I have included a patch to copy the old IO block size into the new IO
>> blocksize, which seems to solve the double free.
>>
>> Thanks,
>> Kit
>>
>> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
>> index 2ad9114..69660ff 100644
>> --- a/lib/ext2fs/openfs.c
>> +++ b/lib/ext2fs/openfs.c
>> @@ -479,6 +479,7 @@ errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io)
>> {
>>      if ((fs->flags & EXT2_FLAG_IMAGE_FILE) == 0)
>>          return EXT2_ET_NOT_IMAGE_FILE;
>> +    new_io->block_size = fs->io->block_size;
>>      fs->io = fs->image_io = new_io;
>>      fs->flags |= EXT2_FLAG_DIRTY | EXT2_FLAG_RW |
>>          EXT2_FLAG_BB_DIRTY | EXT2_FLAG_IB_DIRTY;
>>
