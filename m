From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: new mballoc patches.
Date: Wed, 12 Sep 2007 23:29:43 +0530
Message-ID: <46E8290F.7020307@linux.vnet.ibm.com>
References: <46E651E6.3070107@linux.vnet.ibm.com> <46E6AE84.8050600@linux.vnet.ibm.com> <46E7DF34.8090209@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46332 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXILSCs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2007 14:02:48 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8CI2jcp031840
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 04:02:45 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8CI3m0S192004
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 04:03:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8CIxw0G016574
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 04:59:58 +1000
In-Reply-To: <46E7DF34.8090209@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Valerie,


Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>>
>> running fsstress on ppc64 give me
>> EXT4-fs: group 9: 16384 blocks in bitmap, 32254 in gd
>> EXT4-fs error (device sda7): ext4_mb_mark_diskspace_used: Allocating 
>> block in system zone - block = 294915
>>
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode 
>> #213792: invalid magic - magic 5e5e, entries 24158, max 24158(0), 
>> depth 24158(0)
>> RTAS: event: 137875, Type: Platform Error, Severity: 2
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode 
>> #232149: invalid magic - magic e5e5, entries 58853, max 58853(0), 
>> depth 58853(0)
>> RTAS: event: 137876, Type: Platform Error, Severity: 2
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode 
>> #214332: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_remove_space: bad header in 
>> inode #232149: invalid magic - magic e5e5, entries 58853, max 
>> 58853(0), depth 58853(0)
>>
>> -aneesh
> 
> endian problem?
> When running sparse on fs/ext4/ (make C=2 CF="-D__CHECK_ENDIAN__") :
> 
> fs/ext4/extents.c:2570:12: warning: incorrect type in assignment 
> (different base types)
> fs/ext4/extents.c:2570:12:    expected unsigned long [unsigned] 
> [assigned] allocated
> fs/ext4/extents.c:2570:12:    got restricted unsigned short 
> [addressable] [assigned] [usertype] ee_len
> 
> I think the following line in extents.c
>     allocated = newex.ee_len;
> should be replaced by
>     allocated = le16_to_cpu(newex.ee_len);
> 
> 


Yes i guess that is the issue. fsstress is now running for the last 30 minutes without any error.

I have updated the patch series at 

http://www.radian.org/~kvaneesh/ext4/patch-series/

Changes:
a) mballoc patch fixes for sparse warning
b) ext4_i_version_hi_2.patch patch fixes for sparse warning
c) Added commit message for ext4_uninit_blockgroup.patch
d) Added new patch sparse-fix.patch ( this can be pushed to upstream separately)


The complete patch set in 
http://www.radian.org/~kvaneesh/ext4/patch-series/ext4-patch-queue.tar


-aneesh
