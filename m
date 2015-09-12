From: Johan Harvyl <johan@harvyl.se>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Sat, 12 Sep 2015 12:27:19 +0200
Message-ID: <55F3FE07.9030807@harvyl.se>
References: <55CA3BDE.7020401@harvyl.se> <20150811224718.GD20658@thunk.org>
 <55CBC212.6000507@harvyl.se> <20150813132716.GB26095@thunk.org>
 <55CCDE20.3010108@harvyl.se> <55E8C6AC.5000308@harvyl.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35116 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbILK10 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Sep 2015 06:27:26 -0400
Received: by wicge5 with SMTP id ge5so88886125wic.0
        for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2015 03:27:24 -0700 (PDT)
In-Reply-To: <55E8C6AC.5000308@harvyl.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have now evacuated the data on the filesystem and I *did* manage to 
recreate the
"Should never happen: resize inode corrupt!" using the versions of 
e2fsprogs I believe I was using at the time.

The vast majority of the data that I was able to checksum was ok.

For me I guess the way forward should be to recreate the fs with 1.42.13 
and stick to online resize
from now on, correct?

Are there any feature flags that I should not use when expanding file 
systems or any that I must use?

-johan


Here is a step by step of what I did to reproduce

I have built the following two versions of e2fsprogs (configure, make, 
make install, nothing else):
421d693 (HEAD) libext2fs: fix potential buffer overflow in closefs()
6a3741a (tag: v1.42.12) Update release notes, etc. for final 1.42.12 release

9779e29 (HEAD, tag: v1.42.10) Update release notes, etc. for final 
1.42.10 release

===

First build the fs with 1.42.10 with the exact number of blocks I 
originally had.

# MKE2FS_CONFIG=/root/e10/out/etc/mke2fs.conf 
/root/e10/out/sbin/mkfs.ext4 /dev/md0 -i 262144 -m 0 -O 64bit 15627548672k
mke2fs 1.42.10 (18-May-2014)
/dev/md0 contains a ext4 file system
         created on Sat Sep 12 11:23:02 2015
Proceed anyway? (y,n) y
Creating filesystem with 3906887168 4k blocks and 61045248 inodes
Filesystem UUID: d00e9e59-3756-4e59-9539-bc00fe2446b5
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
         102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
         2560000000, 3855122432

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

 From dumpe2fs I observe:
1) the fs features match what I had on my broken fs
2) the number of free blocks is 512088558484167 which is clearly wrong.

# e2fsck -fnv /dev/md0
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (512088558484167, counted=3902749383).
Fix? no

So the initial fs created by 1.42.10 appear to be bad.

Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID: d00e9e59-3756-4e59-9539-bc00fe2446b5
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent 64bit flex_bg sparse_super large_file huge_file 
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              61045248
Block count:              3906887168
Reserved block count:     0
Free blocks:              512088558484167
Free inodes:              61045237
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      185
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         512
Inode blocks per group:   32
Flex block group size:    16
Filesystem created:       Sat Sep 12 11:27:55 2015
Last mount time:          n/a
Last write time:          Sat Sep 12 11:27:55 2015
Mount count:              0
Maximum mount count:      -1
Last checked:             Sat Sep 12 11:27:55 2015
Check interval:           0 (<none>)
Lifetime writes:          158 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed: f252a723-7016-43d1-97f8-579062a215e1
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000001
Journal start:            0



The next step is resizing + 4 TB with 1.42.12.
# MKE2FS_CONFIG=/root/e12/out/etc/mke2fs.conf 
/root/e12/out/sbin/resize2fs -p /dev/md0 19534435840k
resize2fs 1.42.12 (29-Aug-2014)
<and nothing more>
It did *not* print the "Resizing the filesystem on /dev/md0 to 
4883608960 (4k) blocks." that it should have.

I let it run for 90+ minutes sampling CPU and IO usage with iotop from 
time to time. It was using more or less 100% CPU and no visible io.

So, I let e2fsck fix the free block count and re-did the resize:
# e2fsck -f /dev/md0
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (512088558484167, counted=3902749383).
Fix<y>? yes

/dev/md0: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md0: 11/61045248 files (0.0% non-contiguous), 4137785/3906887168 blocks

# MKE2FS_CONFIG=/root/e12/out/etc/mke2fs.conf 
/root/e12/out/sbin/resize2fs -p /dev/md0 19534435840k
resize2fs 1.42.12 (29-Aug-2014)
Resizing the filesystem on /dev/md0 to 4883608960 (4k) blocks.
Begin pass 2 (max = 6)
Relocating blocks XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 119229)
Scanning inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 5 (max = 8)
Moving inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/md0 is now 4883608960 (4k) blocks long.

dumpe2fs 1.42.13 (17-May-2015)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID: 159d3929-1842-4f8d-907f-7509c16f06df
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent 64bit flex_bg sparse_super large_file huge_file 
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              76306432
Block count:              4883608960
Reserved block count:     0
Free blocks:              4878450712
Free inodes:              76306421
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         512
Inode blocks per group:   32
RAID stride:              32752
Flex block group size:    16
Filesystem created:       Sat Sep 12 11:41:10 2015
Last mount time:          n/a
Last write time:          Sat Sep 12 11:56:20 2015
Mount count:              0
Maximum mount count:      -1
Last checked:             Sat Sep 12 11:49:28 2015
Check interval:           0 (<none>)
Lifetime writes:          279 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed: feeea566-bb38-44c6-a4d5-f97aa78001d4
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000001
Journal start:            0

Looking good so far, and now for the final resize to 24 TB using 1.42.13:
# resize2fs -p /dev/md0
resize2fs 1.42.13 (17-May-2015)
Resizing the filesystem on /dev/md0 to 5860330752 (4k) blocks.
Begin pass 2 (max = 6)
Relocating blocks XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 149036)
Scanning inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 5 (max = 14)
Moving inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Should never happen: resize inode corrupt!

# dumpe2fs -h /dev/md0
dumpe2fs 1.42.13 (17-May-2015)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID: 159d3929-1842-4f8d-907f-7509c16f06df
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent 64bit flex_bg sparse_super large_file huge_file 
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              91568128
Block count:              5860330752
Reserved block count:     0
Free blocks:              5853069550
Free inodes:              91568117
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         512
Inode blocks per group:   32
RAID stride:              32752
Flex block group size:    16
Filesystem created:       Sat Sep 12 11:41:10 2015
Last mount time:          n/a
Last write time:          Sat Sep 12 12:03:55 2015
Mount count:              0
Maximum mount count:      -1
Last checked:             Sat Sep 12 11:49:28 2015
Check interval:           0 (<none>)
Lifetime writes:          279 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed: feeea566-bb38-44c6-a4d5-f97aa78001d4
Journal backup:           inode blocks
Journal superblock magic number invalid!


On 2015-09-04 00:16, Johan Harvyl wrote:
> Hello again,
>
> I finally got around to dig some more into this and made what I 
> consider some good progress as I am now able to mount the filesystem 
> read-only so I thought I would update this thread a bit.
>
> Short one sentence recap since it's been a while since the original 
> post: I am trying to recover a filesystem that was quite badly damaged 
> by an offline resize2fs of a fairly modern ext4fs from 20 TB to 24 TB.
>
> I spent a lot of time trying to get something meaningful out of 
> e2fsck/debugfs and learned quite a bit in the process and I would like 
> to briefly share some observations.
>
> 1) The first hurdle running e2fsck -fnv is that the "Superblock has an 
> invalid journal (inode 8)" is considered fatal and cannot be fixed, at 
> least not in r/o mode so e2fsck just stops, this check needed to go away.
>
> 2) e2fsck gets utterly confused by the "bad block inode" that 
> incorrectly gets identified as having something worth looking at and 
> spends days iterating through blocks (before I cancelled it). Removing 
> handling if ino == EXT2_BAD_INO in pass1 and pass1b made things a bit 
> better.
>
> 3) e2fsck using a backup superblock
> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> e2fsck: Group descriptors look bad... trying backup blocks...
> This is bad, as it means using a superblock that has not been updated 
> with the +4TB. Consequently it gets the location of the first block 
> group wrong, or at the very least the first inode table that houses 
> the root inode.
> Forcing it to use the master superblock again makes things a bit better.
>
> I have some logs from various e2fsck runs with various amounts of 
> hacks applied if they are of any interest to developers? I will also 
> likely have the filesystem in this state for a week or two more if any 
> other information I can extract is of interest to figure out what made 
> resize2fs screw things up.
>
>
>
> In the end, the only actual change I have made to the filesystem to 
> make it mountable is that I borrowed a root inode from a different 
> filesystem and updated the i_block pointer to point to the extent tree 
> corresponding to the root inode of my broken filesystem which was 
> quite easy to find by just looking for the string "lost+found".
>
> # mount -o ro,noload /dev/md0 /mnt/loop
> [2815465.034803] EXT4-fs (md0): mounted filesystem without journal. 
> Opts: noload
>
> # df -h /dev/md0
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md0         22T -382T  404T    - /mnt/loop
>
> Uh oh, does not look to good.. But hey, doing some checks on the data 
> contents and so far results are very promising. An "ls /" looks good 
> and so does a lot of the data that I can verify checksums on, checks 
> are still running...
>
> I really do not know how to move on with trying to repair the 
> filesystem with e2fsck. I do not feel brave enough to let it run r/w 
> on the given how many hacks that I consider very dirty were required 
> to even get it this far. At this point letting it make changes to the 
> filesystem may actually make it worse so I see no other way forward 
> than extracting all the contents and recreating the filesystem from 
> scratch.
>
> Question is though, what is the recommended way to create the 
> filesystem? 64bit is clearly necessary, but what about the other 
> feature flags like flex_bg/meta_bg/resize_inode...? I do not care much 
> about slight gains in performance, robustness is more important, and 
> that it can be resized in the future.
>
> Only online resize from now on, never offlline, I learned that lesson...
>
> Will it be possible to expand from 24 TB to 28 TB online?
>
> thanks,
> -johan
>
>
> On 2015-08-13 20:12, Johan Harvyl wrote:
>> On 2015-08-13 15:27, Theodore Ts'o wrote:
>>> On Thu, Aug 13, 2015 at 12:00:50AM +0200, Johan Harvyl wrote:
>>>
>>>>> I'm not aware of any offline resize with 1.42.13, but it sounds like
>>>>> you were originally using mke2fs and resize2fs 1.42.10, which did 
>>>>> have
>>>>> some bugs, and so the question is what sort of might it might have
>>>>> left things.
>>>> What kind of bugs are we talking about, mke2fs? resize2fs? e2fsck? Any
>>>> specific commits of interest?
>>> I suspect it was caused by a bug in resize2fs 1.42.10.  The problem is
>>> that off-line resize2fs is much more powerful; it can handle moving
>>> file system metadata blocks around, so it can grow file systems in
>>> cases which aren't supported by online resize --- and it can shrink
>>> file systems when online resize doesn't support any kind of file
>>> system shrink.  As such, the code is a lot more complicated, whereas
>>> the online resize code is much simpler, and ultimately, much more
>>> robust.
>> Understood, so would it have been possible to move from my 20 TB -> 
>> 24 TB fs with
>> online resize? I am confused by the threads I see on the net with 
>> regards to this.
>>>> Can you think of why it would zero out the first thousands of
>>>> inodes, like the root inode, lost+found and so on? I am thinking
>>>> that would help me assess the potential damage to the files. Could I
>>>> perhaps expect the same kind of zeroed out blocks at regular
>>>> intervals all over the device?
>>> I didn't realize that the first thousands of inodes had been zeroed;
>>> either you didn't mention this earier or I had missed that from your
>>> e-mail.  I suspect the resize inode before the resize was pretty
>>> terribly corrupted, but in a way that e2fsck didn't complain.
>>
>> Hi,
>>
>> I may not have been clear on that it was not just the first handful 
>> of inodes.
>>
>> When I manually sampled some inodes with debugfs and a disk editor, 
>> the first group
>> I found valid inodes in was:
>>  Group 48: block bitmap at 1572864, inode bitmap at 1572880, inode 
>> table at 1572896
>>
>> With 512 inodes per group that would mean at least some 24k inodes 
>> are blanked out,
>> but I did not check them all, I just sampled groups manually so there 
>> could be some
>> valid in some of the groups below group 48 or a lot more invalid 
>> afterwards.
>>
>>> I'll have to try to reproduce the problem based how you originally
>>> created and grew the file system and see if I can somehow reproduce
>>> the problem.  Obviously e2fsck and resize2fs should be changed to make
>>> this operation much more robust.  If you can tell me the exact
>>> original size (just under 16TB is probably good enough, but if you
>>> know the exact starting size, that might be helpful), and then steps
>>> by which the file system was grown, and which version of e2fsprogs was
>>> installed at the time, that would be quite helpful.
>>>
>>> Thanks,
>>>
>>>                         - Ted
>>
>> Cool, I will try to go through its history in some detail below.
>>
>> If you have ideas on what I could look for, like ideas on if there is 
>> a particular periodicity
>> to the corruption I can write some python to explore such theories.
>>
>>
>> The filesystem was originally created with e2fsprogs 1.42.10-1 and 
>> most likely linux-image
>> 3.14 from Debian.
>>
>> # mkfs.ext4 /dev/md0 -i 262144 -m 0 -O 64bit
>> mke2fs 1.42.10 (18-May-2014)
>> Creating filesystem with 3906887168 4k blocks and 61045248 inodes
>> Filesystem UUID: 13c2eb37-e951-4ad1-b194-21f0880556db
>> Superblock backups stored on blocks:
>>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 
>> 1605632, 2654208,
>>         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 
>> 78675968,
>>         102400000, 214990848, 512000000, 550731776, 644972544, 
>> 1934917632,
>>         2560000000, 3855122432
>>
>> Allocating group tables: done
>> Writing inode tables: done
>> Creating journal (32768 blocks): done
>> Writing superblocks and filesystem accounting information: done
>> #
>>
>> It was expanded with 4 TB (another 976721792 4k blocks). Best I can 
>> tell from my logs this
>> was done with either e2fsprogs:amd64 1.42.12-1 or 1.42.12-1.1 (debian 
>> packages) and
>> Linux 3.16. Everything was running fine after this.
>> NOTE #1: It does *not* look like this filesystem was ever touched by 
>> resize2fs 1.42.10.
>> NOTE #2: The diff between debian packages 1.42.12-1 and 1.42.12-1.1 
>> appear to be this:
>> 49d0fe2 libext2fs: fix potential buffer overflow in closefs()
>>
>> Then for the final 4 TB for a total of 5860330752 4k blocks which was 
>> done with
>> e2fsprogs:amd64 1.42.13-1 and Linux 4.0. This is where the:
>> "Should never happen: resize inode corrupt"
>> was seen.
>>
>> In both cases the same offline resize was done, with no exotic options:
>> # umount /dev/md0
>> # fsck.ext4 -f /dev/md0
>> # resize2fs /dev/md0
>>
>> thanks,
>> -johan
>

