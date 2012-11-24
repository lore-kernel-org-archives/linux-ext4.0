From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: e2fsck repeatedly asks to clear the same entry?
Date: Sat, 24 Nov 2012 12:17:44 -0700
Message-ID: <7BE44E5B-807D-4C20-8D49-88D0394147FD@gmail.com>
References: <k8of5a$sjb$1@ger.gmane.org> <07FA29B6-B150-4A93-B6FF-3072DF31B577@gmail.com> <50B068E3.4090100@unifiedgroup.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Mark Casey <markc@unifiedgroup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2KXTRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Nov 2012 14:17:52 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7140020pbc.19
        for <linux-ext4@vger.kernel.org>; Sat, 24 Nov 2012 11:17:51 -0800 (PST)
In-Reply-To: <50B068E3.4090100@unifiedgroup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-23, at 23:27, Mark Casey <markc@unifiedgroup.com> wrote:

> On 11/23/2012 1:18 PM, Andreas Dilger wrote:
>> On 2012-11-23, at 11:26, Mark Casey <markc@unifiedgroup.com> wrote:
>>> I'm in a bit of a loop trying to fix my ext4 filesystem; it always goes like this even after several passes.
>>> 
>>>> root@host:/home/luser# /root/latest/sbin/e2fsck -f /dev/vgdalr6/lv1
>>>> e2fsck 1.42.5 (29-Jul-2012)
>>>> Pass 1: Checking inodes, blocks, and sizes
>>>> Pass 2: Checking directory structure
>>>> Entry 'A5 11-3' in /share/path/09/Brett/Pines/Flynt's Side Drive - Complete Archive Copy/SA Version Pines/Chris Pics 11-2-10 (268533857) has deleted/unused inode 15115.  Clear<y>? yes
>>>> Pass 3: Checking directory connectivity
>>>> Pass 4: Checking reference counts
>>>> Pass 5: Checking group summary information
>>>> 
>>>> /dev/vgdalr6/lv1: ***** FILE SYSTEM WAS MODIFIED *****
>>>> /dev/vgdalr6/lv1: 8993801/268697600 files (0.8% non-contiguous), 2152234742/4299161600 blocks
>>>> root@host:/home/luser#
>>> 
>>> 
>>> Would anyone have any suggestions how to proceed?
>>> 
>>> The cause of this is that I did an unsupported resize (a shrink) by commenting out one of resize2fs' checks...as described here: (note I'm not claiming this as "permission"; I knew it might not work)
>> 
>> E2fsck should be able to fix (i.e. get into some consistent state) anything regardless of how it got into that state.
>> 
>>> http://article.gmane.org/gmane.comp.file-systems.ext4/35375
>>> 
>>>  this current issue with the directory 'A5 11-3' is the only symptom presenting. I have most of the e2fsck log that followed the resize in case that would be of use.
>> 
>> It would probably be useful to get information from debugfs for this directory and inode (stats, ls -l <268533857>, stat <15115>, and checki 15115).
> 
> I've gathered that info as best I can. Last one didn't want to work. Let me know if there's more:
> 
> * stats *
> Filesystem volume name:   <none>
> Last mounted on:          /home
> Filesystem UUID:          3652885c-e8c6-4f4d-86a0-a4c1d1784557
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              268697600
> Block count:              4299161600
> Reserved block count:     10747903
> Free blocks:              2146933332
> Free inodes:              259703799
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         2048
> Inode blocks per group:   128
> RAID stride:              64
> RAID stripe width:        576
> Flex block group size:    16
> Filesystem created:       Sun Sep  9 18:40:39 2012
> Last mount time:          Fri Nov 23 11:12:16 2012
> Last write time:          Fri Nov 23 12:27:56 2012
> Mount count:              0
> Maximum mount count:      -1
> Last checked:             Fri Nov 23 12:27:56 2012
> Check interval:           0 (<none>)
> Lifetime writes:          12 TB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      94884f6d-8b2e-4830-a33b-02652aee727c
> Journal backup:           inode blocks
> Directories:              258340
> 
> * ls -l *
> 268533857   42757 (2)   1000   1000    4096 22-Nov-2012 12:38 .
> 268304391   42757 (2)   1000   1000    4096 11-Jan-2011 18:06 ..
>  15111   42757 (2)   1000   1000   20480 11-Jan-2011 17:44 Group 1
>  15112   42757 (2)   1000   1000    4096 11-Jan-2011 17:44 Group 2
>  15113   42757 (2)   1000   1000   16384 11-Jan-2011 17:45 Group 3
>  15114   42757 (2)   1000   1000   12288 11-Jan-2011 17:46 Group 4 11-2
>  15115   42757 (2)   1000   1000   36864 11-Jan-2011 17:48 Group 5 11-3

So this is the problematic entry. The directory entry looks ok, though it doesn't have the same name as e2fsck reports. It claims the entry is "A5 11-3", which is a bit bizarre. 

>  15116   42757 (2)   1000   1000   40960 11-Jan-2011 17:51 Group 6 11-4
> 
> * stat *
> User:  1000   Group:  1000   Size: 36864
> File ACL: 0    Directory ACL: 0
> Links: 0   Blockcount: 80
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50ae708d:cb6e6828 -- Thu Nov 22 12:35:57 2012
> atime: 0x504eda66:cb6e6828 -- Tue Sep 11 01:29:58 2012
> mtime: 0x4d2cec69:00000000 -- Tue Jan 11 17:48:57 2011
> crtime: 0x504ed9f5:dab0e61c -- Tue Sep 11 01:28:05 2012
> dtime: 0x50af000c -- Thu Nov 22 22:48:12 2012
> Size of extra inode fields: 28

Both the nlinks here and the dtime show that this inode is deleted, so e2fsck is right in reporting that the directory entry is wrong. 

To fix this manually, you would need to set the inode number for this entry to zero, but I don't recall off the top of my head how to do this. 

>> Normally I'd say that getting a e2image of the filesystem would be useful for debugging and to create a test case, but since the filesystem is 16TB in size that won't be practical.
>> 
>> In the worst case, it should be possible to fix this manually on debugfs either by marking the inode in use in the bitmap (seti 15115) or clear the inode number in the directory entry (on my phone right now and can't check the command for this).
>> 
>> It would be nice to get a test case first, so that e2fsck could be fixed, so if this isn't causing you grief it would be nice to keep this around until there is a chance to understand the problem.
> 
> I'm assuming that with the rest of the fsck coming up clean it is safe to use the filesystem in production come Monday (Samba)?

Yes, though if this directory is accessed it might turn the filesystem read-only. 

> These files are older so I wouldn't mind setting the permissions so that no one can get to them for a bit. What would I need to do to get a test case going?

Just mark the parent directory inaccessible:

# chmod 000 "/share/path/09/Brett/Pines/Flynt's Side Drive - Complete Archive Copy/SA Version Pines/Chris Pics 11-2-10/Group 5 11-3"

Cheers, Andreas
