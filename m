From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: PROBLEM: incorrect data block bitmap after running resize2fs and e2fsck
Date: Fri, 17 Jun 2016 09:25:24 -0600
Message-ID: <7B51A758-2F9E-4020-BF55-31D234E1EFD9@dilger.ca>
References: <1466175303.22666.10.camel@wijtemans.nl>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Lars Wijtemans <lars@wijtemans.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38892 "EHLO
	mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcFQPZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2016 11:25:28 -0400
Received: by mail-it0-f52.google.com with SMTP id h190so71044337ith.1
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jun 2016 08:25:28 -0700 (PDT)
In-Reply-To: <1466175303.22666.10.camel@wijtemans.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted has just released 1.43.1 that fixes a number of problems with 1.42.13. 

You might also consider trying 1.42.13 if you haven't enabled any of the new features in 1.43 (data checksums, inline data, etc.). 

Cheers, Andreas

> On Jun 17, 2016, at 08:55, Lars Wijtemans <lars@wijtemans.nl> wrote:
> 
> After shrinking an ext4 filesystem with resize2fs and running e2fsck
> afterwards, total free blocks count is wrong. Blocks which are "not in
> use" according to debugfs are in fact found to be used by the icheck
> command of debugfs. Subsequent runs of e2fsck report no problems with
> this filesystem.
> 
> 
> == System information
> Linux 4.5.6-200.fc23.x86_64
> e2fsprogs 1.42.13 (17-May-2015)
> 
> 
> == What led to the problem
> I wanted to shrink an ext4 filesystem. The filesystem was created a
> while ago (probably with the -E resize=xyz option) and has been resized
> before.
> It is layered like this: GPT partition | RAID | LUKS | LVM | ext4
> 
> (21694432 MiB total size at this point)
> 
> # e2fsck -f /dev/mapper/foo
> No filesystem problems were found.
> 
> # resize2fs -P /dev/mapper/foo
> (20248275 MiB)
> 
> # resize2fs /dev/mapper/foo 21693408M
> # e2fsck -nf /dev/mapper/foo
> (No filesystem problems were found)
> 
> # resize2fs -p /dev/mapper/foo 21170144M
> # resize2fs -p /dev/mapper/foo 20645856M
> # e2fsck -nf /dev/mapper/foo
> There were a lot of "Free blocks count wrong" wrong messages. Some
> searching on the internet let me to believe this was to be expected, so
> I re-ran with the "preen" option.
> 
> # e2fsck -fp /dev/mapper/foo
> (This completed without any meaningful output)
> 
> The filesystem contained about 19 TiB of data. After mounting, df
> showed only 13 TiB in use. I immediately re-mounted in read-only mode.
> Walking the filesystem still shows a total 19.2 TiB of data that seems
> to be uncorrupted (check ongoing).
> Subsequent runs of e2fsck do not find any problems.
> 
> 
> == Going from here...
> I am concerned that writing to this filesystem will result in data
> loss, since a lot of blocks are (incorrectly) marked as free. It also
> seems like something e2fsck should be able to fix, since the files are
> accessible without problems in read-only mode. I can even imagine
> fixing this through debugfs, by checking whether a block is used by a
> file and, if so, mark it as such.
> 
> What I would like to do is
> 1) figure out why e2fsck is not able to detect/fix this by itself,
> hopefully resulting in an improvement in e2fsck and
> 2) (manually) restore the filesystem to a usable state (within about
> two weeks).
> 
> I'm not familiar with ext4 internals, so any help here is appreciated.
> 
> 
> # df --block-size=4096 /data
> Filesystem                     4K-blocks       Used  Available Use%
> /dev/mapper/vg_datagroup-bulk 5282123045 3385286984 1666833796  68%
> 
> # du --block-size=4096 --summarize --one-file-system /data
> 
> 
> # debugfs /dev/mapper/foo -R "testb 1 5285339135" > /tmp/testb.txt
> Block 1 marked in use
> [...]
> Block 32768 not in use
> [...]
> 
> # grep " not in use" /tmp/testb.txt | wc -l
> 1896836061
> 
> # grep " marked in use" /tmp/testb.txt | wc -l
> 3388503074
> 
> # grep " not in use" /tmp/testb.txt | shuf -n 100 | \
>   awk '{print $2}' | tr '\n' " "
> 265503904 1397137951 924616805 [...]
> 
> These blocks should not have any files associated with them.
> 
> # debugfs /dev/mapper/foo -R "icheck 265503904 1397137951 [...]"
> debugfs 1.42.13 (17-May-2015)
> Block    Inode number
> 265503904    9569537
> 1397137951    8697
> 924616805    4764587
> 920525308    11513483
> 4032323069    <block not found>
> 814305093    1539116
> 246137426    26227968
> 456159649    21
> 277352417    2861448
> [...]
> 
> 
> # dumpe2fs -h /dev/mapper/foo
> dumpe2fs 1.42.13 (17-May-2015)
> Filesystem volume name:   bulk
> Last mounted on:          /data
> Filesystem UUID:          dc0f67cf-85a4-421f-8387-0fb2de7f03ff
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr dir_index filetype
> meta_bg extent 64bit flex_bg sparse_super large_file huge_file
> uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Remount read-only
> Filesystem OS type:       Linux
> Inode count:              41291776
> Block count:              5285339136
> Reserved block count:     229998169
> Free blocks:              1896836061
> Free inodes:              9341404
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Group descriptor size:    64
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         256
> Inode blocks per group:   16
> RAID stride:              128
> RAID stripe width:        768
> First meta block group:   1956
> Flex block group size:    4096
> Filesystem created:       Sun Sep  7 13:05:00 2014
> Last mount time:          Thu Jun 16 10:38:57 2016
> Last write time:          Thu Jun 16 10:39:41 2016
> Mount count:              1
> Maximum mount count:      20
> Last checked:             Thu Jun 16 09:55:23 2016
> Check interval:           1382400 (2 weeks, 2 days)
> Next check after:         Sat Jul  2 09:55:23 2016
> Lifetime writes:          44 TB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:              256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      656e1be4-f041-41c8-a3e8-63827db144bd
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke journal_64bit
> Journal size:             1024M
> Journal length:           262144
> Journal sequence:         0x00192c59
> Journal start:            0
> Bad blocks: 2639100416, 2639100417, [...]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
