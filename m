From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: new mballoc patches.
Date: Tue, 11 Sep 2007 20:34:36 +0530
Message-ID: <46E6AE84.8050600@linux.vnet.ibm.com>
References: <46E651E6.3070107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:33306 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbXIKPKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Sep 2007 11:10:17 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8BFAFQN029878
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 01:10:15 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8BF5A3m1613972
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 01:05:10 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8BF4rgH001040
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 01:04:53 +1000
In-Reply-To: <46E651E6.3070107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> I have updated the mballoc patches. The same can be found at
> 
> http://www.radian.org/~kvaneesh/ext4/patch-series/
> 
> 
> 
>
> 
> Test status:
> Minor testing with KVM. I also didn't do a PPC build.
>

running fsstress on ppc64 give me 

EXT4-fs: group 9: 16384 blocks in bitmap, 32254 in gd
EXT4-fs error (device sda7): ext4_mb_mark_diskspace_used: Allocating block in system zone - block = 294915

EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode #213792: invalid magic - magic 5e5e, entries 24158, max 24158(0), depth 24158(0)
RTAS: event: 137875, Type: Platform Error, Severity: 2
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode #232149: invalid magic - magic e5e5, entries 58853, max 58853(0), depth 58853(0)
RTAS: event: 137876, Type: Platform Error, Severity: 2
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode #214332: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_remove_space: bad header in inode #232149: invalid magic - magic e5e5, entries 58853, max 58853(0), depth 58853(0)

-aneesh
