From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: Ext4 MAX journal size ?
Date: Mon, 07 Dec 2009 15:16:07 -0700
Message-ID: <3470552D-0538-4F6E-BEA4-E85C97148E87@sun.com>
References: <4B1D77B1.8090805@icdsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Iavor Stoev <iavor@icdsoft.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62903 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464AbZLGWQH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 17:16:07 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB7MGDqP014443
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 14:16:14 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KUA00G00YYJLH00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 07 Dec 2009 14:16:13 -0800 (PST)
In-reply-to: <4B1D77B1.8090805@icdsoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-12-07, at 14:46, Iavor Stoev wrote:
> I wonder if the Ext3's MAX journal size of 102,400 file system blocks
> has been increased in Ext4.
>
> I'm using 10TB 4k block Ext3 file system with external journal on  
> Gigabyte I-Ram drive and I'm planning a migration to Ext4 system.
> And I wonder if I can increase the journal size over 400MB.


Well, even with ext3 the maximum journal size was only for internal  
journals.  It was always possible to have larger external journal  
devices.

With ext4, the maximum journal size WAS increased, though this is in  
fact a mke2fs/tune2fs limit so it is also increased for new ext3  
filesystems.

Note that with large journals you are also consuming an equal amount  
of RAM as the size of the journal, so don't make it crazy big.  Having  
a journal on SSD is only really noticable for sync-happy workloads.   
It isn't noticably better than using a regular disk for the external  
journal if you aren't doing a lot of syncs (e.g. NFS or email).

I've thought in the past that it might be an interesting hack to use a  
huge journal device (say 32GB) with data journaling, and then have the  
JBD layer get the data blocks from the journal for checkpointing to  
the filesystem instead of keeping the buffers pinned in RAM.  That  
would would allow blazing metadata workloads, zero seeking, and then  
checkpointing in bulk to the filesystem.  ... but unfortunately not  
something I have time to test out.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

