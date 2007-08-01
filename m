From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] e2fsprogs: Add undoe2fs
Date: Wed, 01 Aug 2007 13:22:30 +0530
Message-ID: <46B03BBE.1060309@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <47f96570519d76b8d59f92b729a0a48c4a1b68d8.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <20070801060211.GO5469@schatzie.adilger.int> <46B02539.5020505@linux.vnet.ibm.com> <20070801071032.GQ5469@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41282 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbXHAHze (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 03:55:34 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l717v3SP312254
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 17:57:22 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l717pq1X249538
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 17:51:52 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l717qc2k025400
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 17:52:38 +1000
In-Reply-To: <20070801071032.GQ5469@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Aug 01, 2007  11:46 +0530, Aneesh Kumar K.V wrote:
>> Andreas Dilger wrote:
>>> On Aug 01, 2007  07:34 +0530, Aneesh Kumar K.V wrote:
>>>> undoe2fs can be used to replay the transaction saved
>>>> in the transaction file using undo I/O Manager
>>> This should save the mtime of the superblock, and only do the undo
>>> step if the filesystem hasn't changed.  Otherwise it could seriously
>>> corrupt the filesystem.
>> I am not sure i understand this. The Undo I/O manager tracks all the write
>> happening to the file system and copy the original content of the blocks to
>> the tdb file. Undoe2fs simply copies these blocks back to the file system. 
>>
>> That way if you look at undoe2fs it doesn't have any knowledge of the file
>> system at all.
>>
>> Can you let me know a use case where this will fail.
> 
> - modify filesystem with undo manager (e.g. inode resize)
> - mount filesystem, make changes, unmount
> - run undoe2fs to overwrite filesystem, corrupting it
> 


But that won't corrupt it. It will bring the file system back to
the state before inode resize. I understand that we may want to have

a) Don't replay if file system is mounted
b) Don't replay if UUID doesn't match


But i guess we should allow a replay if file system got changed afterwards.
Ofcourse the changes will no longer be available after the replay.

-aneesh
