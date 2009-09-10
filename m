From: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Subject: Re: ext4+quota+nfs issue
Date: Thu, 10 Sep 2009 05:21:46 +0200
Message-ID: <4AA870CA.906@primeinteractive.net>
References: <4AA5E5F3.30309@primeinteractive.net>	 <4AA72C14.1020005@primeinteractive.net>	 <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz>	 <4AA7C38E.8020306@redhat.com> <1252531929.19097.174.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.primeinteractive.net ([195.95.205.253]:36683 "EHLO
	mail.primeinteractive.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbZIJDWG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 23:22:06 -0400
In-Reply-To: <1252531929.19097.174.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9. 9. 2009 23:32, Mingming wrote:
> On Wed, 2009-09-09 at 10:02 -0500, Eric Sandeen wrote:
>    
>> Jiri Kosina wrote:
>>      
>>> [ adding relevant CCs ]
>>>
>>> On Wed, 9 Sep 2009, Pavol Cvengros wrote:
>>>
>>>        
>>>> Hi,
>>>>
>>>> can somebody who is aware of ext4 and quota have a look on this one?
>>>>
>>>>          
>> This was also just reported at:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=521914
>>
>>      
> Checked the bugzilla, it seems the fs enabled quota, but no user quota
> limit is specified. Is this the case with the ext4 quota+ nfs issue too?
>
> If no user quota is specified, then IS_NOQUOTA() should avoid doing
> quota reservation/claim at all. Not sure what is missing... I will check
> if I could reproduce this on local filesystem...
>
> Thanks,
> Mingming
>    
yes, FS has quota just enabled and only initial quotacheck was done

P.

>> -Eric
>>
>>      
>>>> Thanks,
>>>>
>>>> P.
>>>>
>>>> On 8. 9. 2009 7:04, Pavol Cvengros wrote:
>>>>          
>>>>> Hello,
>>>>>
>>>>> recently we have build and started to use raid storage with formatted
>>>>> capacity of 4.5T (ext4 formatted, default params).
>>>>> FS has quota turned on and is exported via NFS to nodes.
>>>>> If we turn qouta on on this FS and are trying to use it over NFS we get the
>>>>> following:
>>>>>
>>>>> ------------[ cut here ]------------
>>>>> WARNING: at fs/quota/dquot.c:964 dquot_claim_space+0x181/0x190()
>>>>> Hardware name: S3210SH
>>>>> Modules linked in: nfs fscache nfsd lockd auth_rpcgss exportfs sunrpc
>>>>> coretemp hwmon ipmi_si ipmi_msghandler ehci_hcd sr_mod cdrom uhci_hcd floppy
>>>>> usbcore i2c_i801 i2c_core processor 3w_9xxx button thermal
>>>>> Pid: 268, comm: pdflush Tainted: G        W  2.6.30-gentoo-r3_host #1
>>>>> Call Trace:
>>>>>   [<ffffffff803151e1>] ? dquot_claim_space+0x181/0x190
>>>>>   [<ffffffff80245c59>] ? warn_slowpath_common+0x89/0x100
>>>>>   [<ffffffff803151e1>] ? dquot_claim_space+0x181/0x190
>>>>>   [<ffffffff80367e83>] ? ext4_mb_mark_diskspace_used+0x423/0x440
>>>>>   [<ffffffff8036c05f>] ? ext4_mb_new_blocks+0x2cf/0x460
>>>>>   [<ffffffff80360a17>] ? ext4_ext_find_extent+0x307/0x330
>>>>>   [<ffffffff80362508>] ? ext4_ext_get_blocks+0x578/0xfc0
>>>>>   [<ffffffff8028e828>] ? __pagevec_free+0x48/0x70
>>>>>   [<ffffffff803a1c65>] ? blk_rq_bio_prep+0x35/0x130
>>>>>   [<ffffffff8034d310>] ? ext4_get_blocks_wrap+0x210/0x380
>>>>>   [<ffffffff8034d8d8>] ? mpage_da_map_blocks+0xe8/0x750
>>>>>   [<ffffffff80292cee>] ? pagevec_lookup_tag+0x2e/0x50
>>>>>   [<ffffffff8029084c>] ? write_cache_pages+0x11c/0x400
>>>>>   [<ffffffff8034e500>] ? __mpage_da_writepage+0x0/0x190
>>>>>   [<ffffffff8034e269>] ? ext4_da_writepages+0x329/0x4b0
>>>>>   [<ffffffff80290bd2>] ? do_writepages+0x32/0x70
>>>>>   [<ffffffff802e4140>] ? __writeback_single_inode+0xb0/0x490
>>>>>   [<ffffffff8023c753>] ? dequeue_entity+0x23/0x1c0
>>>>>   [<ffffffff802e4b16>] ? generic_sync_sb_inodes+0x316/0x4f0
>>>>>   [<ffffffff802e4f4e>] ? writeback_inodes+0x5e/0x110
>>>>>   [<ffffffff80290e56>] ? wb_kupdate+0xc6/0x160
>>>>>   [<ffffffff80292110>] ? pdflush+0x120/0x230
>>>>>   [<ffffffff80290d90>] ? wb_kupdate+0x0/0x160
>>>>>   [<ffffffff80291ff0>] ? pdflush+0x0/0x230
>>>>>   [<ffffffff80261154>] ? kthread+0x64/0xc0
>>>>>   [<ffffffff8020d13a>] ? child_rip+0xa/0x20
>>>>>   [<ffffffff802610f0>] ? kthread+0x0/0xc0
>>>>>   [<ffffffff8020d130>] ? child_rip+0x0/0x20
>>>>> ---[ end trace cb54e6523e9ab60d ]---
>>>>>
>>>>> fstab entry:
>>>>> /dev/sdb1              /mnt/storage    ext4
>>>>> noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0
>>>>>
>>>>> qith quotaoff on tihs FS, warnings stop.
>>>>>
>>>>> Question is if it's safe to use quotas with this problem (warning) or not.
>>>>> Can't afford data damage.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Pavol Cvengros
>>>>>            
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>      
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

