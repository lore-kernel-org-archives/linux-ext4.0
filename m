From: Rusty Conover <rconover@infogears.com>
Subject: Re: OOPS BUG at fs/ext4/inode.c:1853
Date: Tue, 2 Feb 2010 22:30:39 -0500
Message-ID: <D4C80345-358A-4065-9591-2B25F1E5C71E@infogears.com>
References: <7897FA4C-4600-4872-A003-BBB6B099785D@infogears.com> <20100203025422.GC16384@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100203025422.GC16384@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 2, 2010, at 9:54 PM, tytso@mit.edu wrote:

> On Tue, Feb 02, 2010 at 08:25:44PM -0500, Rusty Conover wrote:
>> Hi,
>> 
>> Here is a kernel oops using the latest fedora 12 kernel.  Machine is
>> a Intel(R) Xeon(R) CPU E5430 @ 2.66GHz, running in 32bit mode,
>> normal SATA disks.  Filesystem was created in fedora 10, and machine
>> upgraded via yum to Fedora 12.  Is reproducible using "stress-1.0.2"
>> from http://weather.ou.edu/~apw/projects/stress/
> 
> Thanks for the bug report!

Thanks for the reply!

> Can you send us the output of dumpe2fs -h on the filesystem in
> question, and the exact Fedora 12 kernel version?  This is a quad-core
> machine, right?  How much memory did you have installed in the
> machine?

Kernel version:
2.6.31.12-174.2.3.fc12.i686.PAE #1 SMP Mon Jan 18 20:06:44 UTC 2010 i686 i686 i386 GNU/Linux

Yes this is a quad core machine.  

There is 16 Gigs of ram installed in the machine.

dumpe2fs 1.41.9 (22-Aug-2009)
Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          ec711783-a186-466e-a175-ac1fb30dddf7
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              28835840
Block count:              115340656
Reserved block count:     5767032
Free blocks:              96094336
Free inodes:              27927481
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      996
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Jan  5 16:15:36 2009
Last mount time:          Tue Feb  2 16:17:09 2010
Last write time:          Tue Feb  2 16:17:08 2010
Mount count:              29
Maximum mount count:      -1
Last checked:             Mon Jan  5 16:15:36 2009
Check interval:           0 (<none>)
Lifetime writes:          1158 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       101263
Default directory hash:   half_md4
Directory Hash Seed:      dd38dd1a-5e43-4e35-8c96-db5ac377591b
Journal backup:           inode blocks
Journal size:             128M


> How long did you you have to run the script before the oops triggered?
> I haven't been able to trigger it using the latest ext4 tree running
> under KVM (but that's only emulating two, not four cores).  Next up is
> the mainline tree, and then stock 2.6.32.6....

PID 27992 was the one that crashed. So it took about 5.5 hours.

Here is the process table:

root     27988  0.0  0.0   1912   468 pts/1    S+   10:49   0:00 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27989 74.6  0.0   1912   184 pts/1    R+   10:49 209:04 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27990  5.5  0.0   1912   176 pts/1    D+   10:49  15:32 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27991 76.7  0.2 132988 41760 pts/1    R+   10:49 214:58 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27992 10.4  0.0   2864  1264 pts/1    D+   10:49  29:14 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27993 74.5  0.0   1912   184 pts/1    R+   10:49 208:38 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27994 74.3  0.0   1912   184 pts/1    R+   10:49 208:13 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1
root     27995 74.5  0.0   1912   184 pts/1    R+   10:49 208:44 ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1

We've found that the time until the kernel crashes varies. 

> Eric can probably test
> F12 kernel faster than I can (I do have an F12 machine that Red Hat
> has graciously lent me, but due to travel and a new job it hasn't been
> hooked up yet, and I can only use it when I'm at home; so I probably
> won't have time to test on that machine until the weekend).
> 

We can get you remote access to the machine if that'd be helpful to you.

Thanks,

Rusty
--
Rusty Conover
rconover@infogears.com
InfoGears Inc / GearBuyer.com / FootwearBuyer.com
http://www.infogears.com
http://www.gearbuyer.com
http://www.footwearbuyer.com
