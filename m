From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: fragmentation optimization
Date: Sun, 24 Sep 2017 21:01:04 +0200
Message-ID: <7820e328-ee34-27f1-2a70-1e40da85dd1c@uls.co.za>
References: <6f6eb640-cd31-7080-a575-b7c6c4dd9e3f@uls.co.za>
 <333A80A7-9254-41C8-ACCE-5094CFD050EA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from othala.uls.co.za ([154.73.34.12]:44633 "EHLO othala.uls.co.za"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752728AbdIXTBW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 24 Sep 2017 15:01:22 -0400
In-Reply-To: <333A80A7-9254-41C8-ACCE-5094CFD050EA@dilger.ca>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Thanks for the feedback.


On 23/09/2017 19:12, Andreas Dilger wrote:
> -- snip --
>> I'm also relatively comfortable to make the 30s write limit even longer (as you pointed out the files causing the problems are typically 300GB+ even though on average my files are very small), permitting that I won't introduce additional file-system corruption risk.  Also keeping in mind that I run anything from 10 to 20 concurrent rsync instances at any point in time.
> The 30s limit is imposed by the VFS, which begins flushing dirty data pages
> from memory if they are old, if some other mechanism hasn't done it sooner.
Understood.  Not a major issue, nor do I think I really have enough RAM 
to cache for much longer than that anyway (32GB, of which rsync 
processes can trivially consume around 12-16GB, 16GB remaining, and 
there is till a lot of read caches that needs to be handled (directory 
structures etc ...)
>> I would like to attempt such a patch, so if you (or someone else) could possibly point me in an appropriate direction of where to start work on this I would really appreciate the help.
>>
>> Another approach for me may be to simply switch off --sparse since especially now I'm unsure of it's benefit.  I'm guessing that I could do a sweep of all inodes to determine how much space is really being saved by this.
> You can do this on a per-file basis with the "filefrag" utility to determine how
> many extents the file is written in.  Anything reporting only 1 extent can be
> ignored since it can't get better. Even on large files there will be multiple
> extents (maximum extent size is 128MB, but may be limited to ~122MB depending on
> formatting options).  That said, anything larger than ~4MB doesn't improve the
> I/O performance in any significant way because the HDD seek rate 100/sec * 4MB/s
> exceeds the disk bandwidth.
> The other option is the "fsstats" utility (https://github.com/adilger/fsstats
> though I didn't write it) will scan the whole filesystem/tree and report all
> kinds of useful stats, but most importantly how many files are sparse.
Thanks.  filefrag looks  One could also use stat to determine this saving:

# stat -c "%i %h %s %b" filename
635047698 15 98304 72

So the first number is just because in case where %h is >1 you'd need to 
keep track of inodes already checked.  With 100m files that may get 
quite a big set so filtering %h==1 may be a good idea. Given the above 
the file size is 98304 and 72 * 512 == 36864, so (assuming we've got 4K 
blocks) 98304 implies 24 blocks in terms of virtual space, and 72 / 8 
implies 9 blocks actually allocated. Based on that file it's quite a 
saving in terms of %, but in terms of actual GB ... time will tell.  
Going to take a few days to

Switching off --sparse may not be quite as trivial unless I can simply 
force it off on the recipient side (I do use forced command for ssh 
authorized keys ... so can modify the command to be executed).

Either way ... I think that Ted is right, the "feature" whereby holes 
are left on disk might be causing problems in this case and even if it's 
a mount option to optionally disable it, I think it would be a good 
thing to have that control.  Having the default value of that option be 
dependent on delayed allocation is up for debate, but based on the 
binutils scenario the "feature" is definitely a good idea without 
delayed allocation.
>> [1] My observed behaviour when syncing a file (without --inplace which is in my opinion a bad idea in general unless you're severely space constrained, and then I honestly don't know how this situation would be affected) is that rsync will create a new file, and then the file size of this file will grow slowly (not, not disk usage, but size as reported by ls) until it reaches the file size of the new file, and at this point rsync will use rename(2) to replace the old file with the new one (which is the right approach).
> The reason the size is growing, but not the blocks count, is because of delayed
> allocation.  The ext4 code will keep the dirty pages only in memory until they
> need to be written (due to age or memory pressure), to better determine what to
> allocate on disk.  This lets it fit small files into small free chunks on disk,
> and large files get (multiple) large free chunks of disk.
I merely looked at the size reported, I never did check the block size.  
I know that the size implied by disk blocks won't exceed the size 
reported by ls by more than filesystem block size (typically 4K).  So 
merely looking at the file size which is increasing the assumption was 
that allocated blocks would also increase over time (even if delayed, 
doesn't matter).  A hole that's left will however never allocate a 
block, for example:

$ dd if=/dev/zero bs=4096 seek=9 count=1 of=foo
1+0 records in
1+0 records out
4096 bytes (4.1 kB, 4.0 KiB) copied, 2.0499e-05 s, 200 MB/s
$ ls -la foo
-rw-r--r-- 1 jkroon jkroon 40960 Sep 24 20:54 foo
$ du -sh foo
4.0K    foo

Now, if a process were to write to block 0, then skip a block, and then 
write to block one, with the current scheme that would leave a block 
physically on disk open, which in my case is undesirable, but given VMs 
again, may be desirable.  So this is not a simple debate. I think an 
explicit mount option to disable the feature whereby physical blocks is 
skipped is probably the best (initially at least) approach.

Kind Regards,
Jaco
