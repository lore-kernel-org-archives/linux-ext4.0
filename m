From: Kai Grosshaus <kai@vbcl.de>
Subject: Re: Can't resize2fs - combination of flex_bg and !resize_inode
Date: Mon, 27 Aug 2012 13:37:11 +0200
Message-ID: <k1fm57$n9$1@ger.gmane.org>
References: <0FB0C67C-CF56-4589-857F-8B57BC25AB7D@gmail.com> <20120821030245.GA4222@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60913 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2H0LkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Aug 2012 07:40:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1T5xfn-000541-RN
	for linux-ext4@vger.kernel.org; Mon, 27 Aug 2012 13:40:03 +0200
Received: from host-94-230-48-88.customer.ign-dns.de ([94.230.48.88])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2012 13:40:03 +0200
Received: from kai by host-94-230-48-88.customer.ign-dns.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2012 13:40:03 +0200
In-Reply-To: <20120821030245.GA4222@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 21.08.2012 05:02, schrieb Theodore Ts'o:
> On Mon, Aug 20, 2012 at 03:18:35AM -0400, Curtis Jones wrote:
>> Hi. I hope this is the right list for ext4-related user questions. If not, please point me in the right direction.
>>
>> I recently set up my first software raid with mdadm and after adding more disks to the raid I am unable to resize the filesystem to the full size of the raid. I created a single (~16TB) filesystem on /dev/md0 via:
>>
>> 	mkfs.ext4 -v -b 4096 -t huge -E stride=128,stripe-width=256 /dev/md0
>
> This is wrong.  It should have been
>
> mke2fs -v -b 4096 -t ext4 -T huge -E stride=128,stripe-width=256 /dev/md0
>
> Unfortunately -t huge overrode the ".ext4" in "mkfs.ext4", leading to
> an incorrect set of file system options.  I didn't expect people would
> try to use do this.  I'll have to improve mke2fs's error handling to
> prevent the -t/-T confusion.
>
> That being said, you must have a non-standard /etc/mke2fs.conf file,
> since when I tried your command line, here's the file system features
> that I ended up with:
>
> Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super large_file
>
> This wouldn't have given you any of ext4's advanced features, but
> resize2fs should have worked in that case.
>
> Can you send me the output of "dumpe2fs -h /dev/md0", and your
> /etc/mke2fs.conf file?
>
>> While I await any suggestions, I'm going to look at a more
>> up-to-date versions of these tools. Please let me know if I need to
>> provide any more information. I *really* would like to find out that
>> there's a way to resize the fs without having to recreate the
>> fs. Copying all of this data off and back on would be painful.
>
> Yes, you should definitely get a newer version of e2fsprogs.  The
> latest version is 1.42.5.
>
> As to whether you'll need to recreate the filesystem, I'll need to see
> the output of dumpe2fs -h.  It may be that file system was created in
> sufficiently poor configuration that it would be highly advisable that
> you recreate the file system.
>
> My apologies for the confusion with the options parsing.  Originally
> the goal was to allow new fs-types (ext2/ext3/ext4) specified with -t,
> and new usage-types (huge/big/small/etc.) specified with -T, to be
> defined via new stanzas in /etc/mke2fs.conf.  The problem came when we
> also added backwards compatibility support for argv[0] being set to
> mkfs.<fs-type>.
>
> That's not something I normally use --- I normally use mke2fs and
> e2fsck directly --- and so it didn't occur to me that there would be
> confusion if someone confused -t and -T while using an argv[0] of
> mkfs.ext4.
>
> Regards,
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,

I,ve got the same problem. I tried it with e2fsprogs from Ubuntu 12.04 
(1.4.2) and v1.42.5 from git repository. As mke2fs.conf i used the one 
from git, I guess there is no need to post it here ;)

cmd used to create fs:

mke2fs -t ext4 -T huge -O resize_inode \
-E stride=256,stripe-width=2048 /dev/sde1

the result is the same with both versions, here the dumpe2fs:

dumpe2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          901e6200-8e6a-4ea5-92c1-5f0f6502b302
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype extent 
64bit flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              366211072
Block count:              5859352064
Reserved block count:     292967603
Free blocks:              5836000801
Free inodes:              366211061
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
RAID stride:              256
RAID stripe width:        2048
Flex block group size:    16
Filesystem created:       Mon Aug 27 13:18:02 2012
Last mount time:          n/a
Last write time:          Mon Aug 27 13:18:16 2012
Mount count:              0
Maximum mount count:      -1
Last checked:             Mon Aug 27 13:18:02 2012
Check interval:           0 (<none>)
Lifetime writes:          173 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      45b36dc8-4c59-453c-88d3-cb6b69747ffd
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000001
Journal start:            0


and now the resize cmd:

resize2fs -p /dev/sde1 18000G

resize2fs 1.42.5 (29-Jul-2012)
resize2fs: /dev/sde1: The combination of flex_bg and
         !resize_inode features is not supported by resize2fs.

I've found this patch while googling, but i don't know if it is a 
solution for this problem. Heres the link:

http://www.spinics.net/lists/linux-ext4/msg20570.html


Thanks.

Kai Grosshaus







