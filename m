From: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Subject: Re: ext4+quota+nfs issue
Date: Wed, 09 Sep 2009 19:19:34 +0200
Message-ID: <4AA7E3A6.8050404@primeinteractive.net>
References: <4AA5E5F3.30309@primeinteractive.net> <4AA72C14.1020005@primeinteractive.net> <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz> <20090909144622.GB7949@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753842AbZIIRUB@vger.kernel.org>
In-Reply-To: <20090909144622.GB7949@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/9/2009 4:46 PM, Jan Kara wrote:
> On Wed 09-09-09 11:42:03, Jiri Kosina wrote:
>    
>> [ adding relevant CCs ]
>>      
>    Thanks.
>
>    
>> On Wed, 9 Sep 2009, Pavol Cvengros wrote:
>>      
>>>> recently we have build and started to use raid storage with formatted
>>>> capacity of 4.5T (ext4 formatted, default params).
>>>> FS has quota turned on and is exported via NFS to nodes.
>>>> If we turn qouta on on this FS and are trying to use it over NFS we get the
>>>> following:
>>>>
>>>> ------------[ cut here ]------------
>>>> WARNING: at fs/quota/dquot.c:964 dquot_claim_space+0x181/0x190()
>>>> Hardware name: S3210SH
>>>> Modules linked in: nfs fscache nfsd lockd auth_rpcgss exportfs sunrpc
>>>> coretemp hwmon ipmi_si ipmi_msghandler ehci_hcd sr_mod cdrom uhci_hcd floppy
>>>> usbcore i2c_i801 i2c_core processor 3w_9xxx button thermal
>>>> Pid: 268, comm: pdflush Tainted: G        W  2.6.30-gentoo-r3_host #1
>>>> Call Trace:
>>>>   [<ffffffff803151e1>] ? dquot_claim_space+0x181/0x190
>>>>   [<ffffffff80245c59>] ? warn_slowpath_common+0x89/0x100
>>>>   [<ffffffff803151e1>] ? dquot_claim_space+0x181/0x190
>>>>   [<ffffffff80367e83>] ? ext4_mb_mark_diskspace_used+0x423/0x440
>>>>   [<ffffffff8036c05f>] ? ext4_mb_new_blocks+0x2cf/0x460
>>>>   [<ffffffff80360a17>] ? ext4_ext_find_extent+0x307/0x330
>>>>   [<ffffffff80362508>] ? ext4_ext_get_blocks+0x578/0xfc0
>>>>   [<ffffffff8028e828>] ? __pagevec_free+0x48/0x70
>>>>   [<ffffffff803a1c65>] ? blk_rq_bio_prep+0x35/0x130
>>>>   [<ffffffff8034d310>] ? ext4_get_blocks_wrap+0x210/0x380
>>>>   [<ffffffff8034d8d8>] ? mpage_da_map_blocks+0xe8/0x750
>>>>   [<ffffffff80292cee>] ? pagevec_lookup_tag+0x2e/0x50
>>>>   [<ffffffff8029084c>] ? write_cache_pages+0x11c/0x400
>>>>   [<ffffffff8034e500>] ? __mpage_da_writepage+0x0/0x190
>>>>   [<ffffffff8034e269>] ? ext4_da_writepages+0x329/0x4b0
>>>>   [<ffffffff80290bd2>] ? do_writepages+0x32/0x70
>>>>   [<ffffffff802e4140>] ? __writeback_single_inode+0xb0/0x490
>>>>   [<ffffffff8023c753>] ? dequeue_entity+0x23/0x1c0
>>>>   [<ffffffff802e4b16>] ? generic_sync_sb_inodes+0x316/0x4f0
>>>>   [<ffffffff802e4f4e>] ? writeback_inodes+0x5e/0x110
>>>>   [<ffffffff80290e56>] ? wb_kupdate+0xc6/0x160
>>>>   [<ffffffff80292110>] ? pdflush+0x120/0x230
>>>>   [<ffffffff80290d90>] ? wb_kupdate+0x0/0x160
>>>>   [<ffffffff80291ff0>] ? pdflush+0x0/0x230
>>>>   [<ffffffff80261154>] ? kthread+0x64/0xc0
>>>>   [<ffffffff8020d13a>] ? child_rip+0xa/0x20
>>>>   [<ffffffff802610f0>] ? kthread+0x0/0xc0
>>>>   [<ffffffff8020d130>] ? child_rip+0x0/0x20
>>>> ---[ end trace cb54e6523e9ab60d ]---
>>>>
>>>> fstab entry:
>>>> /dev/sdb1              /mnt/storage    ext4
>>>> noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0
>>>>
>>>> qith quotaoff on tihs FS, warnings stop.
>>>>
>>>> Question is if it's safe to use quotas with this problem (warning) or not.
>>>> Can't afford data damage.
>>>>          
>    The warning definitely doesn't directly indicate a danger of data loss.
> But there *is* some bug causing that ext4 asks for more quota space than
> it has reserved.
>    From your report it seems it is easily reproducible, right? Do you have
> an easy way to trigger this warning - by some test script or so?
>
> 								Honza
>    
really easy to reproduce, our storage is on live production so I can't 
experiment with kernel but it's enough to do quotaon and system will get 
"spammed" with these warning on every file access..

P.
