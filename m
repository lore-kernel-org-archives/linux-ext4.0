From: Iavor Stoev <iavor@icdsoft.com>
Subject: Re: Ext4 MAX journal size ?
Date: Tue, 08 Dec 2009 18:43:10 +0200
Message-ID: <4B1E821E.4060809@icdsoft.com>
References: <4B1D77B1.8090805@icdsoft.com> <3470552D-0538-4F6E-BEA4-E85C97148E87@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icdsoft.com ([64.14.68.165]:47559 "EHLO us.icdsoft.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbZLHQnD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 11:43:03 -0500
In-Reply-To: <3470552D-0538-4F6E-BEA4-E85C97148E87@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Andreas,

Thank you for your fast reply!

We use this setup for our backup servers.
We use rsync via SSH using hard links as backup technology; the backup 
server is pulling the data from several servers.

The setup is 12x1TB disks in RAID6 128k stripe, using ext3 4k block + 
lvm2 with the journal on Gigabyte I-RAM drive 1GB DDR400.
The server has 8GB RAM.

The journal mode is data.
The journal size is 400MB.

When we moved the journal on the external device we have gained like 20%
performance improvement with our backup.
I'm converting several servers to ext4 to see what will be the 
performance improvement for our workload.

Do you have any suggestions regarding the journal size and the overall 
file system setup?

Thank you again!

Iavor


Andreas Dilger wrote:
> On 2009-12-07, at 14:46, Iavor Stoev wrote:
>> I wonder if the Ext3's MAX journal size of 102,400 file system blocks
>> has been increased in Ext4.
>>
>> I'm using 10TB 4k block Ext3 file system with external journal on 
>> Gigabyte I-Ram drive and I'm planning a migration to Ext4 system.
>> And I wonder if I can increase the journal size over 400MB.
> 
> 
> Well, even with ext3 the maximum journal size was only for internal 
> journals.  It was always possible to have larger external journal devices.
> 
> With ext4, the maximum journal size WAS increased, though this is in 
> fact a mke2fs/tune2fs limit so it is also increased for new ext3 
> filesystems.
> 
> Note that with large journals you are also consuming an equal amount of 
> RAM as the size of the journal, so don't make it crazy big.  Having a 
> journal on SSD is only really noticable for sync-happy workloads.  It 
> isn't noticably better than using a regular disk for the external 
> journal if you aren't doing a lot of syncs (e.g. NFS or email).
> 
> I've thought in the past that it might be an interesting hack to use a 
> huge journal device (say 32GB) with data journaling, and then have the 
> JBD layer get the data blocks from the journal for checkpointing to the 
> filesystem instead of keeping the buffers pinned in RAM.  That would 
> would allow blazing metadata workloads, zero seeking, and then 
> checkpointing in bulk to the filesystem.  ... but unfortunately not 
> something I have time to test out.
> 
> Cheers, Andreas
> -- 
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

