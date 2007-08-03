From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] e2fsprogs: Add undo I/O manager
Date: Fri, 03 Aug 2007 10:19:43 +0530
Message-ID: <46B2B3E7.3030807@linux.vnet.ibm.com>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com> <20070801225247.GC5692@schatzie.adilger.int> <46B22340.5020709@linux.vnet.ibm.com> <20070802213728.GH6142@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51280 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbXHCEtz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 00:49:55 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l734qfuM140894
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 14:52:41 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l734mxf4247412
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 14:48:59 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l734nmJc020047
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 14:49:48 +1000
In-Reply-To: <20070802213728.GH6142@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Aug 03, 2007  00:02 +0530, Aneesh Kumar K.V wrote:
>> Andreas Dilger wrote:
>>> Is this the mtime and UUID of the new filesystem or the old one?  It
>>> should be the UUID and mtime of the new filesystem, so that the
>>> undo file can be verified against the current superblock.  This poses
>>> a bit of a problem, because that information isn't saved until after
>>> the mke2fs run is finished.
>>>
>>> One possibility is to overwrite this information at the end of mke2fs
>>> after the new UUID and mtime are written?
>> This can be done by writing the file system identity during the the 
>> io_channel_close.
>> How about this patch on top of the last series. I will merge this into the 
>> patcheset
> 
> I thought about this also, but in fact for most uses of the undo manager
> we want to save the information at the start instead of the end, so it
> is possible to undo e.g. a partial e2fsck that crashes before it finishes.
> Only with mke2fs (and, I guess tune2fs -U) does the UUID change at the
> end.

I am not sure whether saving the information at start is needed. I understand
that what we are looking for is the case when the application crashes without
doing a io_channel_close. In that case i would say the user can use the
--force option and replay the data from the tdb file. The UUID could very well
be changed on the disk before the application crashed. So even if we save
UUID at the start, there are cases where it won't match with the disk UUID.


That actually brings me to another change. I would be moving the block size
recording changes from write_file_system_identity to a separate function 
and will be calling it at the first write. That make sure we have a record
that carry the blocksize even though we don't have one with mtime and UUID
in the tdb file.


> 
> Also, can you check if mke2fs does any non-iomanager output?  I think
> there is code to "zap" the old superblock at the start and old RAID info
> at the end of the block device, and I'm not sure if this uses the normal
> IO manager or not.
> 


The zap_sector and zap_zero uses the io manager to zero out the blocks. So
they should be ok. I found that when we use -J device=<journal-device>. mke2fs
uses unix I/O manager to write to the journal super block. I guess that is ok
because we are not tracking changes to journal device.

I found that the journal_super_block have only space for 48 s_users
UUID entries. But in ext2fs_add_journal_device we are not checking
the limit. Does that mean repeated mke2fs with -J can lead to corruption ?

-aneesh 
