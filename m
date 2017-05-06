From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: More inline data oddities
Date: Sat, 06 May 2017 18:41:31 +0200
Message-ID: <590DFCBB.4010706@partition-saving.com>
References: <20170501174001.3541.qmail@ns.sciencehorizons.net> <04BDD82D-B764-49A8-9F5B-71303BE96857@dilger.ca> <20170503131550.GA14305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
        Zheng Liu <wenqing.lz@taobao.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:35183 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdEFQio (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 6 May 2017 12:38:44 -0400
In-Reply-To: <20170503131550.GA14305@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

You can quite easily create a directory with inline_data and an not zero block 
count.
Just create a directory and set on it several posix ACL (40 in my case for a 512 
bytes inode).
Then you get something like:
Inode: 12   Type: directory    Mode:  0775   Flags: 0x10000000
Generation: 3148309105    Version: 0x00000000:00000006
User:  1000   Group:  1000   Project:     0   Size: 384
File ACL: 7978    Directory ACL: 0
Links: 7   Blockcount: 2
Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x590dccec:a9cc6410 -- Sat May  6 15:17:32 2017
  atime: 0x590dc07d:1f9f101c -- Sat May  6 14:24:29 2017
  mtime: 0x590dccec:a9cc6410 -- Sat May  6 15:17:32 2017
crtime: 0x590dc069:de64cc44 -- Sat May  6 14:24:09 2017
Size of extra inode fields: 32
Extended attributes:
   system.data (324)
   system.posix_acl_access (340)
Size of inline data: 384

This does not seems an error and in my case e2fsck does not complain.
Both inline data content and ACL block are correct.

So perhaps is there something else wrong in George's case. Perhaps getting block 
1496481792 content could help to check if it has some ACL header or not.

Regards,

Damien
PS: I got some error on George's domain so add to remove it from recipient, hope 
he could seen it on the list and this one was no sent twice

Zheng Liu wrote:
> Hello Andreas,
> 
> Thanks for letting me know this.
> 
> Hello George,
> 
> I have tried to create a ext4 file system with inline_data feature,
> and try to create a directory hierarchy like you described in the
> mail.  But unfortunately I couldn't reproduce your issue.  That would
> be great if you could provide more details to me, such as the output
> of the following command.
> 
>   $ debugfs ${DEV} -R 'stats'
> 
>>From this command I can know which features are enabled in your ext4
> file system and that would help me to reproduce the problem.  Further,
> could you please tell me your kernel version?
> 
> On Mon, May 01, 2017 at 04:00:02PM -0600, Andreas Dilger wrote:
> 
>>Add the original inline data author Zheng Liu <wenqing.lz@taobao.com>.
>>
>>On May 1, 2017, at 11:40 AM, George Spelvin <linux@sciencehorizons.net> wrote:
>>
>>>[255031.626936] EXT4-fs warning (device md3): ext4_dirent_csum_verify:352: inode #1461410: comm find: No space for directory leaf checksum. Please run e2fsck -D.
>>>[255031.626940] EXT4-fs error (device md3): ext4_readdir:198: inode #1461410: comm find: path $PATH1: directory fails checksum at offset 0
>>>[255035.720542] EXT4-fs warning (device md3): ext4_dirent_csum_verify:352: inode #1461314: comm find: No space for directory leaf checksum. Please run e2fsck -D.
>>>[255035.720547] EXT4-fs error (device md3): ext4_readdir:198: inode #1461314: comm find: path $PATH2: directory fails checksum at offset 0
> 
> 
> It seems that the space is full in inline data and the kernel could not
> expand it to a new block.  From the following message I guess during
> this process kernel tries to allocate a new block for this directory
> and then an error is encountered that causes flags 0x10000000 could not
> have a chance to be cleared.  So this inode has flag 0x10000000 and
> blockcount is 8.
> 
> 
>>>
>>>The inline data consists of two parts: 60 bytes in the block pointers which
>>>hold the first four entries, and 72 bytes in an ea, which holds the fifth and
>>>last entry.
>>>
>>>debugfs on the directories reveals the following:
>>>Inode: 1461410   Type: directory    Mode:  0755   Flags: 0x10000000
> 
>                                                       ^^^^^^^^^^^^^^^^^
>                           It means that this directory contains inline data
> 
> 
>>>Generation: 927521379    Version: 0x00000000:00000007
>>>User:  1000   Group:    11   Project:     0   Size: 132
>>>File ACL: 1496481792    Directory ACL: 0
>>>Links: 3   Blockcount: 8
> 
>                ^^^^^^^^^^^^^
> It seems that this directory is currupted because a directory with
> inline data should be 0.  That is why e2fsck wants to fix this issue
> in first round.
> 
> I will take a closer look at this problem later, and thanks for
> reporting this.
> 
> Regards,
>                                                 - Zheng
> 
> 
>>>Fragment:  Address: 0    Number: 0    Size: 0
>>>ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>mtime: 0x55016b84:e7729ec8 -- Thu Mar 12 06:33:40 2015
>>>crtime: 0x56c1c093:0d01b4b4 -- Mon Feb 15 07:12:03 2016
>>>Size of extra inode fields: 32
>>>Extended attributes:
>>> system.data (72)
>>>Inode checksum: 0x456bd90c
>>>Size of inline data: 132
>>>
>>>Inode: 1461314   Type: directory    Mode:  0755   Flags: 0x10000000
>>>Generation: 927521364    Version: 0x00000000:00000004
>>>User:  1000   Group:    11   Project:     0   Size: 132
>>>File ACL: 1496383488    Directory ACL: 0
>>>Links: 3   Blockcount: 8
>>>Fragment:  Address: 0    Number: 0    Size: 0
>>>ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>mtime: 0x55016b84:1670325c -- Thu Mar 12 06:33:40 2015
>>>crtime: 0x56c1c093:01161e74 -- Mon Feb 15 07:12:03 2016
>>>Size of extra inode fields: 32
>>>Extended attributes:
>>> system.data (72)
>>>Inode checksum: 0x008d7abf
>>>Size of inline data: 132
>>>
>>>
>>>If I run e2fsck on that stat, it complains about two things:
>>>
>>>Inode 1461314, i_blocks is 8, should be 0.  Fix<y>? yes
>>>Inode 1461410, i_blocks is 8, should be 0.  Fix<y>? yes
>>>i_file_acl for inode 1461314 ($PATH2) is 1496383488, should be zero.
>>>Clear<y>? yes
>>>i_file_acl for inode 1461410 ($PATH1) is 1496481792, should be zero.
>>>Clear<y>? yes
>>>
>>>I don't really understand how those two errors were created in the
>>>first place.
>>>
>>>However, after saying yes to those, the system.data ea is missing and the
>>>final entries in each directory get dropped, leading to being dumped
>>>in loat+found.
>>>
>>>Here's the state after the first e2fsck run completes:
>>>
>>>Inode: 1461410   Type: directory    Mode:  0755   Flags: 0x10000000
>>>Generation: 927521379    Version: 0x00000000:00000007
>>>User:  1000   Group:    11   Project:     0   Size: 132
>>>File ACL: 0    Directory ACL: 0
>>>Links: 3   Blockcount: 0
>>>Fragment:  Address: 0    Number: 0    Size: 0
>>>ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>mtime: 0x55016b84:e7729ec8 -- Thu Mar 12 06:33:40 2015
>>>crtime: 0x56c1c093:0d01b4b4 -- Mon Feb 15 07:12:03 2016
>>>Size of extra inode fields: 32
>>>Inode checksum: 0xcd34b98c
>>>Size of inline data: 60
>>>
>>>Inode: 1461314   Type: directory    Mode:  0755   Flags: 0x10000000
>>>Generation: 927521364    Version: 0x00000000:00000004
>>>User:  1000   Group:    11   Project:     0   Size: 132
>>>File ACL: 0    Directory ACL: 0
>>>Links: 3   Blockcount: 0
>>>Fragment:  Address: 0    Number: 0    Size: 0
>>>ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
>>>mtime: 0x55016b84:1670325c -- Thu Mar 12 06:33:40 2015
>>>crtime: 0x56c1c093:01161e74 -- Mon Feb 15 07:12:03 2016
>>>Size of extra inode fields: 32
>>>Inode checksum: 0x042ed119
>>>Size of inline data: 60
>>>
>>>
>>>This then leads to a second run complaining about
>>>
>>>Inode 1461314 has INLINE_DATA_FL flag but extended attribute not found.  Truncate<y>?
>>>
>>>If I instead fix it by "ea_set -f /dev/null <1461314> system.data", I get the
>>>directory back in a relatively unbroken state.  But why is system.data
>>>being deleted in the first place?
>>
>>
>>Cheers, Andreas
>>
>>
>>
>>
>>
> 
> 
> 
> 
