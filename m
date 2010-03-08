From: Paul Chavent <paul.chavent@fnac.net>
Subject: Re: Constant access (write) time.
Date: Mon, 08 Mar 2010 21:17:03 +0100
Message-ID: <4B955B3F.8070004@fnac.net>
References: <4B92D10D.8070805@fnac.net> <20100306231327.GI6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41993 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab0CHUM2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Mar 2010 15:12:28 -0500
In-Reply-To: <20100306231327.GI6000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.

Thank you for your reply.

I have an intel SSD 2.5 inch X25-M 80GB SATA300. And i have the following log :

# /test_ext4
        file size        duration
         58157568        11809470
         62773248        10658968
        266786304        11514789
        287403008        10423548
        308327424        13095972
        329251840        11036123
        350176256        12643903
        370792960         9767548
        391717376        10987771
        411410944        13204409
^C
diff min : 2298627
diff moy : 3971804
diff max : 13204409
1342 iterations
major pagefaults : 0
minor pagefaults : 0


Could you give me more detail on your configuration ?

Here, more details on mine :

# mke2fs -t ext4 -L DATA -O large_file,^has_journal,extent -v /dev/sda3
mke2fs 1.41.9 (22-Aug-2009)
fs_types for mke2fs.conf resolution: 'ext4', 'default'
Filesystem label=DATA
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
3670016 inodes, 14653288 blocks
732664 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=0
448 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
         4096000, 7962624, 11239424

Writing inode tables: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 37 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

# dumpe2fs -h /dev/sda3
dumpe2fs 1.41.9 (22-Aug-2009)
Filesystem volume name:   DATA
Last mounted on:          <not available>
Filesystem UUID:          13b72368-2a9e-11df-8a9f-0060c2140392
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              3670016
Block count:              14653288
Reserved block count:     732664
Free blocks:              14409685
Free inodes:              3670005
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1020
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Mar  8 10:33:46 2010
Last mount time:          n/a
Last write time:          Mon Mar  8 10:34:00 2010
Mount count:              0
Maximum mount count:      37
Last checked:             Mon Mar  8 10:33:46 2010
Check interval:           15552000 (6 months)
Next check after:         Sat Sep  4 10:33:46 2010
Lifetime writes:          900 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Default directory hash:   half_md4
Directory Hash Seed:      13b723f4-2a9e-11df-8a9f-0060c2140392

# mount -t ext4 -o noatime,nodiratime /dev/sda3 /var/data
EXT4-fs (sda3): no journal
EXT4-fs (sda3): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda3): mounted filesystem without journal

# hdparm -i /dev/sda

/dev/sda:
hdparm: ioctl 0x304 failed: Inappropriate ioctl for device

  Model=INTEL SSDSA2MH080G1GC                   , FwRev=045C8820, SerialNo=CVEM8385003E080DGN
  Config={ Fixed }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=0
  BuffType=(0) unknown, BuffSize=0kB, MaxMultSect=16, MultSect=?1?
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=156301488
  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: ATA/ATAPI-7 T13 1532D rev.1:  ATA/ATAPI-2 ATA/ATAPI-3 ATA/ATAPI-4 ATA/ATAPI-5 ATA/ATAPI-6 ATA/ATAPI-7

  * current active mode



tytso@mit.edu wrote:
> On Sat, Mar 06, 2010 at 11:02:53PM +0100, Paul Chavent wrote:
>> Hello.
>>
>> I'm writing a real-time application that have to stream pictures to a SSD.
>>
>> The pictures are 640x480x1 pnm that are stored in one tar file. I
>> have one picture every 100ms.
>>
>> The problem is that the access (write) time (from a userspace point
>> of view) is not constant. I join you a piece of code that reproduce
>> the problem.
> 
> What are you seeing/expecting?  Here's what I'm getting with the X25-M
> Intel SSD:
> 
>        file size        duration
> 
> diff min : 3666548
> diff moy : 6639261
> diff max : 9429924
> 101 iterations
> major pagefaults : 0
> minor pagefaults : 0
> 
> It's rarely if ever triggering your "suspect write" fprintf.
> 
>> This leads me to ask the following questions : the solution to this
>> problem is
>>
> 
> If you are seeing something seriously worse, you might want to test
> what happens if you write to the SSD directly; it may be the answer is
> 
> (4) Buy a competently engineered SSD.  :-)
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

