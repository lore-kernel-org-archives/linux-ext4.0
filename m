From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: can't get e4defrag to work
Date: Mon, 26 Jan 2009 16:41:53 +0900
Message-ID: <497D6941.7010509@rs.jp.nec.com>
References: <7a45233b0901210704w5038d8b8g5c657e3a4746f34d@mail.gmail.com>	 <49797056.7030607@rs.jp.nec.com> <7a45233b0901231108i55e8b504va8b9b00c0a38a80e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: Derkjan de Haan <haanjdj@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57481 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZAZHmQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 02:42:16 -0500
In-Reply-To: <7a45233b0901231108i55e8b504va8b9b00c0a38a80e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Derkjan,

Derkjan de Haan wrote:
> Hi Akira,
>
> Just got e4defrag to work - to a certain degree. I'm using Fedora 10,
> which has ext4 as a module. This produces the problem described here:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00701.html
>
> (the patch 'ext4: Add a delayed allocation debugging ioctl' doesn't
> export inode_lock -> I reverted this patch)

I see.   :-)

> But now I'm bitten by the fact that Fedora 10 creates ext4 filesystems
> with the flex_bg feature enabled, which seems to be incompatible with
> e4defrag. I also can't seem to clear that flag. tune2fs refuses this,
> and if try using debugfs the flag gets cleared, but when running
> e2fsck it gets restored again, so I'm basically stuck here.

The new online defrag handles the flex_bg feature correctly,
so you will be able to run e4defrag on the Fedora 10 soon.

Regards,
Akira Fujita

> 
> 2009/1/23 Akira Fujita <a-fujita@rs.jp.nec.com>:
>> Hi Derkjan,
>>
>> Thank you for using ext4 onlie defrag.
>>
>> I tried to use the same kernel and command
>> (2.6.28 +
>> http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out.tar.bz2
>> )
>> and I got a fine result as follows.
>>
>> [root@bsd086 broken-out]# ./e4defrag  -v /mnt/mp1/file1
>> ext4 defragmentation for /mnt/mp1/file1
>> [1/1]/mnt/mp1/file1:    100%  extents: 3 -> 1    [ OK ]
>>  Success:            [1/1]
>>
>> My environment was:
>> [root@bsd086 broken-out]# uname -a
>> Linux bsd086 2.6.28 #2 SMP Thu Jan 22 09:55:13 JST 2009 i686 i686 i386
>> GNU/Linux
>>
>> [root@bsd086 broken-out]# mount
>> /dev/sda8 on /mnt/mp1 type ext4 (rw)
>>
>> [root@bsd086 broken-out]# debugfs /dev/sda8
>> ..
>> Filesystem features:      has_journal ext_attr resize_inode dir_index
>> filetype n
>> eeds_recovery extent sparse_super large_file huge_file uninit_bg dir_nlink
>> extra
>> _isize
>> Filesystem flags:         signed_directory_hash
>> Default mount options:    (none)
>> Filesystem state:         clean
>> Errors behavior:          Continue
>> Filesystem OS type:       Linux
>> Inode count:              61824
>> Block count:              246991
>> Reserved block count:     12349
>> Free blocks:              223339
>> Free inodes:              61810
>> First block:              0
>> Block size:               4096
>> Fragment size:            4096
>> Reserved GDT blocks:      60
>> Blocks per group:         32768
>> Fragments per group:      32768
>> Inodes per group:         7728
>> ..
>>
>>
>> Did you turn off the flex_bg feature in your case?
>> But the message "Inappropriate ioctl for device" you had is not
>> related to the flex_bg.
>> Something related to ioctl might be wrong in your case.
>>
>> Were there any reject or hunks when you applied patches to kernel?
>> Did you boot with correct kernel?
>> I have no idea so can you tell me the detail of your test environment?
>>
>> By the way, ext4 online defrag in the current ext4 patch queue (2.6.29-rc1)
>> does not work fine, because defrag does not handle some new ext4 functions
>> correctly.
>> Therefore Ted commented them out recently.
>>
>> I'm preparing to release new online defrag patches now.
>> Probably it will be the next week.
>> I appreciate it if you try to use new one as well.
>>
>> Thanks,
>> Akira Fujita
>>
>>
>> Derkjan de Haan wrote:
>>> Dear Sirs,
>>>
>>> I have tried to compile a usable e4defrag but to no avail. It doesn't
>>> defrag anything, and in verbose mode it reports: "Defrag
>>> fail:Inappropriate ioctl for device".
>>>
>>> I have downloaded a stock 2.6.28 kernel, and applied all patches in
>>>
>>> http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out.tar.bz2
>>> I have uncommented the defrag patches (except -00 (the changelog) and
>>> -09 (the defrag tool) in the series file, and run "quilt push -a". It
>>> reports all patches applied successfully. An example e4defrag run
>>> looks like this:
>>>
>>> [root@toshiba ~]# ./e4defrag -v .
>>> ext4 defragmentation for directory(.)
>>> [1/31] "/root"
>>>        File is not regular file                [ NG ]
>>> [2/31] "/root/.gnupg"
>>>        File is not regular file                [ NG ]
>>> [3/31]/root/.gnupg/gpg.conf:      0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [4/31] "/root/.gnupg/pubring.gpg"
>>>        File size is 0          [ NG ]
>>> [5/31]/root/e4defrag:     0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [6/31] "/root/Mail"
>>>        File is not regular file                [ NG ]
>>> [7/31]/root/defrag-09-online-defrag-command.c:    0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [8/31] "/root/.gconfd"
>>>        File is not regular file                [ NG ]
>>> [9/31]/root/.gconfd/saved_state:          0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [10/31]/root/.bashrc:     0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [11/31] "/root/.kde"
>>>        File is not regular file                [ NG ]
>>> [12/31] "/root/.kde/cache-toshiba.badmuts.org"
>>>        File is not regular file                [ NG ]
>>> [13/31] "/root/.kde/tmp-toshiba.badmuts.org"
>>>        File is not regular file                [ NG ]
>>> [14/31]/root/.lesshst:    0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [15/31] "/root/.ketchup"
>>>        File is not regular file                [ NG ]
>>> [16/31]/root/.ketchup/patch-2.6.29-rc2.bz2:       0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [17/31]/root/install.log.syslog:          0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [18/31]/root/.bash_logout:        0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [19/31]/root/.bash_history:       0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [20/31]/root/.bash_profile:       0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [21/31]/root/anaconda-ks.cfg:     0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [22/31] "/root/.lftp"
>>>        File is not regular file                [ NG ]
>>> [23/31]/root/.lftp/rl_history:    0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [24/31]/root/.lftp/transfer_log:          0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [25/31]/root/.lftp/cwd_history:   0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [26/31]/root/.cshrc:      0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [27/31]/root/install.log:         0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [28/31]/root/.tcshrc:     0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [29/31] "/root/.ssh"
>>>        File is not regular file                [ NG ]
>>> [30/31]/root/.ssh/known_hosts:    0%
>>>        Defrag fail:Inappropriate ioctl for device      [ NG ]
>>> [31/31] "/root/.gconf"
>>>        File is not regular file                [ NG ]
>>>
>>>        Success:                        [ 0/31 ]
>>>        Failure:                        [ 31/31 ]
>>>        Total extents:                    36->36
>>>        Fragmented percentage:           20%->20%
>>>
>>> I must be doing something wrong, but I can't figure out what. Do you
>>> have any hints?
>>>
>>> Kind regards,
>>>
>>>
>>> Derkjan de Haan
>>>
> 
