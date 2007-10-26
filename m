From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: problem with delayed allocation option
Date: Fri, 26 Oct 2007 20:27:03 +0530
Message-ID: <4722003F.4020009@linux.vnet.ibm.com>
References: <4721DD74.20806@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57731 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbXJZP2T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2007 11:28:19 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9QEv5Jn005788
	for <linux-ext4@vger.kernel.org>; Sat, 27 Oct 2007 00:57:05 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9QF0ebx275806
	for <linux-ext4@vger.kernel.org>; Sat, 27 Oct 2007 01:00:40 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9QEv5Ri001137
	for <linux-ext4@vger.kernel.org>; Sat, 27 Oct 2007 00:57:06 +1000
In-Reply-To: <4721DD74.20806@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Valerie Clement wrote:
> Hi all,
> 
> I ran a small test which creates one directory and 2O 8-KB size files in 
> it.
> 
> When the filesystem is mounted without the delalloc option, here is the
> output of the command dumpe2fs for the group in which the directory and 
> the files are created:
> 
> Group 532 : (Blocks 17432576-17465343)
>   Block bitmap at 17432576 (+0), Inode bitmap at 17432577 (+1)
>   Inode table at 17432578-17433089 (+2)
>   32213 free blocks, 16363 free inodes, 1 directories
>   Free blocks : 17433090-17459199, 17459241-17465343
>   Free inodes : 8716310-8732672
> 
> 
> When the filesystem is mounted with the delalloc option, the same test
> gives a different result:
> 
> Group 395 : (Blocks 12943360-12976127)
>   Block bitmap at 12943360 (+0), Inode bitmap at 12943361 (+1)
>   Inode table at 12943362-12943873 (+2)
>   32213 free blocks, 16363 free inodes, 1 directories
>   Free blocks : 12943874-12955647, 12955650-12955655, 12955658-12955663, 
> 12955666-12955671, 12955674-12955679, 12955682-12955687, 
> 12955690-12955695, 12955698-12955703, 12955706-12955711, 
> 12955714-12955719, 12955722-12955727, 12955730-12955735, 
> 12955738-12955743, 12955746-12955751, 12955754-12955759, 
> 12955762-12955767, 12955770-12955775, 12955778-12955783, 
> 12955786-12955791, 12955794-12955799, 12955802-12961791, 12961793-12976127
>   Free inodes : 6471702-6488064
> 


I am finding both the case to be equally distributed. Tried
-o mballoc,delalloc and -o nomballoc,nodelalloc and ext3

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do dd if=/dev/zero of=mytest$i bs=1024 count=8; done


nodelalloc,nomballoc
---------------
Free blocks: 25017-25088, 25097-25600, 25609-26112, 26121-26624, 26633-27136, 27145-27648, 27657-28160, 28169-28672, 28682-29184, 29201-29696, 29713-30208, 30225-30720, 30737-31232, 31241-31744, 31753-32256, 32265-32768

delalloc,mballoc
-----------
Free blocks: 16624-16896, 16905-17408, 17417-17920, 17929-18432, 18441-18944, 18954-19456, 19465-19968, 19985-20480, 20497-20992, 21009-21504, 21521-22016, 22025-22528, 22537-23040, 23049-23552, 23561-24064, 24073-24576

with ext3
--------
Free blocks: 25017-25088, 25097-25600, 25609-26112, 26121-26624, 26633-27136, 27145-27648, 27658-28160, 28169-28672, 28689-29184, 29201-29696, 29713-30208, 30225-30720, 30729-31232, 31241-31744, 31753-32256, 32265-32768
