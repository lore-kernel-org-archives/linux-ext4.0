From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: "EXT4-fs error: ext4_mb_generate_buddy" errors during rsync
Date: Mon, 18 Mar 2013 10:51:19 +0100
Message-ID: <20130318095119.GB379@x4>
References: <20130318081551.GA379@x4>
 <20130318095851.GA1751@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:35562 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3CRJvV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2013 05:51:21 -0400
Content-Disposition: inline
In-Reply-To: <20130318095851.GA1751@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013.03.18 at 17:58 +0800, Zheng Liu wrote:
> On Mon, Mar 18, 2013 at 09:15:51AM +0100, Markus Trippelsdorf wrote:
> > During the nightly rsync run that backups my root filesystem I got:
> > 
> > Mar 18 01:52:00 x4 fcron[19997]: Job /usr/bin/rsnapshot daily started for user root (pid 19998)
> > Mar 18 01:56:41 x4 rsnapshot[20187]: /usr/bin/rsnapshot daily: completed successfully
> > Mar 18 01:56:43 x4 fcron[19997]: Job /usr/bin/rsnapshot daily completed (mailing output)
> > 
> > Mar 18 01:52:21 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6817, 7060 clusters in bitmap, 7064 in gd
> > Mar 18 01:52:21 x4 kernel: JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> > Mar 18 01:56:30 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6833, 26653 clusters in bitmap, 26656 in gd
> > Mar 18 01:56:30 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6881, 3985 clusters in bitmap, 3991 in gd
> > Mar 18 01:56:30 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6897, 5979 clusters in bitmap, 6024 in gd
> > 
> > e2fsck 1.42 (29-Nov-2011)
> > Pass 1: Checking inodes, blocks, and sizes
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> > Free blocks count wrong for group #6817 (6779, counted=6775).
> > Fix<y>? yes
> > Free blocks count wrong for group #6833 (26575, counted=26572).
> > Fix<y>? yes
> > Free blocks count wrong for group #6881 (3916, counted=3910).
> > Fix<y>? yes
> > Free blocks count wrong for group #6897 (5987, counted=5942).
> > Fix<y>? yes
> > Free blocks count wrong (185850303, counted=185850245).
> > Fix<y>? yes
> > /dev/sdb: ***** FILE SYSTEM WAS MODIFIED *****
> > /dev/sdb: 1619858/91578368 files (0.6% non-contiguous), 180434401/366284646 blocks
> > 
> > "smartctl -a /dev/sda" looks fine
> 
> Hi Markus,
> 
> Could you please provide more details?  Such as kernel version, `tune2fs
> -l ${dev}`, etc....  I guess the kernel version is 3.9-rc2, right? :-)

Yes, I'm running latest git with "tytso/ext4.git dev" already pulled in.

Please note that tonight was the first time I saw this error and I run
rsync every night. So the problem is not reproducible.

tune2fs 1.42.7 (21-Jan-2013)
Filesystem volume name:   <none>
Last mounted on:          /var
Filesystem UUID:          202f2c93-c6c5-4d70-a63f-d770161138bd
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              91578368
Block count:              366284646
Reserved block count:     18314232
Free blocks:              185850351
Free inodes:              89958540
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      936
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Nov 19 16:02:46 2012
Last mount time:          Mon Mar 18 08:57:21 2013
Last write time:          Mon Mar 18 08:57:21 2013
Mount count:              2
Maximum mount count:      -1
Last checked:             Mon Mar 18 08:53:39 2013
Check interval:           0 (<none>)
Lifetime writes:          2992 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       52166759
Default directory hash:   half_md4
Directory Hash Seed:      e86f34a0-390a-49b6-87a9-3336d861ab81
Journal backup:           inode blocks

/dev/sda       ext4      1.4T  667G  640G  52% /var
/dev/sda on /var type ext4 (rw,noatime,data=ordered)

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   114   099   006    Pre-fail  Always       -       895168
  3 Spin_Up_Time            0x0003   093   092   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       76
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       32
  7 Seek_Error_Rate         0x000f   060   056   030    Pre-fail  Always       -       382342884998
  9 Power_On_Hours          0x0032   080   080   000    Old_age   Always       -       18043
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       52
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   099   099   000    Old_age   Always       -       1
188 Command_Timeout         0x0032   100   094   000    Old_age   Always       -       46
189 High_Fly_Writes         0x003a   094   094   000    Old_age   Always       -       6
190 Airflow_Temperature_Cel 0x0022   069   059   045    Old_age   Always       -       31 (Min/Max 21/34)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       17
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       77
194 Temperature_Celsius     0x0022   031   041   000    Old_age   Always       -       31 (0 19 0 0 0)
195 Hardware_ECC_Recovered  0x001a   022   007   000    Old_age   Always       -       895168
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       2
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       170475841928047
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       2862958769
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       2221200126

-- 
Markus
