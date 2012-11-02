From: Mark Casey <markc@unifiedgroup.com>
Subject: Re: Can't resize2fs - combination of flex_bg and !resize_inode
Date: Thu, 01 Nov 2012 20:17:13 -0500
Message-ID: <50931F19.2090304@unifiedgroup.com>
References: <0FB0C67C-CF56-4589-857F-8B57BC25AB7D@gmail.com> <20120821030245.GA4222@thunk.org> <k1fm57$n9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54338 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2KBBUA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2012 21:20:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1TU5vX-0003Iw-RU
	for linux-ext4@vger.kernel.org; Fri, 02 Nov 2012 02:20:03 +0100
Received: from 63.64.43.126 ([63.64.43.126])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 02 Nov 2012 02:20:03 +0100
Received: from markc by 63.64.43.126 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 02 Nov 2012 02:20:03 +0100
In-Reply-To: <k1fm57$n9$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/27/2012 6:37 AM, Kai Grosshaus wrote:
> Am 21.08.2012 05:02, schrieb Theodore Ts'o:
>> On Mon, Aug 20, 2012 at 03:18:35AM -0400, Curtis Jones wrote:
>>> Hi. I hope this is the right list for ext4-related user questions. If
>>> not, please point me in the right direction.
>>>
>>> I recently set up my first software raid with mdadm and after adding
>>> more disks to the raid I am unable to resize the filesystem to the
>>> full size of the raid. I created a single (~16TB) filesystem on
>>> /dev/md0 via:
>>>
>>>     mkfs.ext4 -v -b 4096 -t huge -E stride=128,stripe-width=256 /dev/md0
>>
>> This is wrong.  It should have been
>>
>> mke2fs -v -b 4096 -t ext4 -T huge -E stride=128,stripe-width=256 /dev/md0
>>
>> Unfortunately -t huge overrode the ".ext4" in "mkfs.ext4", leading to
>> an incorrect set of file system options.  I didn't expect people would
>> try to use do this.  I'll have to improve mke2fs's error handling to
>> prevent the -t/-T confusion.
>>
>> That being said, you must have a non-standard /etc/mke2fs.conf file,
>> since when I tried your command line, here's the file system features
>> that I ended up with:
>>
>> Filesystem features:      ext_attr resize_inode dir_index filetype
>> sparse_super large_file
>>
>> This wouldn't have given you any of ext4's advanced features, but
>> resize2fs should have worked in that case.
>>
>> Can you send me the output of "dumpe2fs -h /dev/md0", and your
>> /etc/mke2fs.conf file?
>>
>>> While I await any suggestions, I'm going to look at a more
>>> up-to-date versions of these tools. Please let me know if I need to
>>> provide any more information. I *really* would like to find out that
>>> there's a way to resize the fs without having to recreate the
>>> fs. Copying all of this data off and back on would be painful.
>>
>> Yes, you should definitely get a newer version of e2fsprogs.  The
>> latest version is 1.42.5.
>>
>> As to whether you'll need to recreate the filesystem, I'll need to see
>> the output of dumpe2fs -h.  It may be that file system was created in
>> sufficiently poor configuration that it would be highly advisable that
>> you recreate the file system.
>>
>> My apologies for the confusion with the options parsing.  Originally
>> the goal was to allow new fs-types (ext2/ext3/ext4) specified with -t,
>> and new usage-types (huge/big/small/etc.) specified with -T, to be
>> defined via new stanzas in /etc/mke2fs.conf.  The problem came when we
>> also added backwards compatibility support for argv[0] being set to
>> mkfs.<fs-type>.
>>
>> That's not something I normally use --- I normally use mke2fs and
>> e2fsck directly --- and so it didn't occur to me that there would be
>> confusion if someone confused -t and -T while using an argv[0] of
>> mkfs.ext4.
>>
>> Regards,
>>
>>                         - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Hi,
>
> I,ve got the same problem. I tried it with e2fsprogs from Ubuntu 12.04
> (1.4.2) and v1.42.5 from git repository. As mke2fs.conf i used the one
> from git, I guess there is no need to post it here ;)
>
> cmd used to create fs:
>
> mke2fs -t ext4 -T huge -O resize_inode \
> -E stride=256,stripe-width=2048 /dev/sde1
>
> the result is the same with both versions, here the dumpe2fs:
> ...

Hello,

I'm in the same boat I'm afraid, but I do have a question. I'm curious 
whether the issue with the combination of flex_bg and !resize_inode can 
cause problems *shrinking* the filesystem, or if it is only a risk when 
growing it(?). I need to shrink the fs to get enough space for LVM 
snapshots. I figure that if shrinking is not an issue I could just 
compile a version of e2fsprogs without the check for this feature 
combination, just to use this once. I mean, I already have to reformat 
so I'm no worse off if it doesn't work. Any thoughts on the likelihood 
of that working?

Here are some details:
My filesystem (~16T) was also created under Ubuntu 12.04 using the 
included e2fsprogs 1.42 with no changes to mke2fs.conf. It is now being 
used under Ubuntu 8.04 but I've installed e2fsprogs v1.42.5.

I don't have the exact mkfs command that I used to create it on hand, 
but if it matters I know I called it as mkfs.ext4, I set stride and 
stripe-width appropriately, used a 1G journal, and used something around 
'-m .25'

dumpe2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          /media/dlr6
Filesystem UUID:          3652885c-e8c6-4f4d-86a0-a4c1d1784557
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype 
needs_recovery extent 64bit flex_bg sparse_super large_file huge_file 
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              272199680
Block count:              4355184640
Reserved block count:     10887961
Free blocks:              2325348918
Free inodes:              263549083
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
RAID stride:              64
RAID stripe width:        576
Flex block group size:    16
Filesystem created:       Sun Sep  9 18:40:39 2012
Last mount time:          Tue Oct 30 20:03:15 2012
Last write time:          Tue Oct 30 20:03:15 2012
Mount count:              16
Maximum mount count:      -1
Last checked:             Sun Sep  9 18:40:39 2012
Check interval:           0 (<none>)
Lifetime writes:          10 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       213188625
Default directory hash:   half_md4
Directory Hash Seed:      94884f6d-8b2e-4830-a33b-02652aee727c
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             1024M
Journal length:           262144
Journal sequence:         0x024d20c1
Journal start:            1

Thanks in advance for any insight,
Mark

