From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: What represent 646345728 bytes
Date: Mon, 01 Feb 2010 22:50:12 +0530
Message-ID: <871vh427qr.fsf@linux.vnet.ibm.com>
References: <7618835.18201265033304935.JavaMail.www@wsfrf1112>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: paul.chavent@fnac.net, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55809 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0BARUQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 12:20:16 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp06.in.ibm.com (8.14.3/8.13.1) with ESMTP id o11HKFIs025304
	for <linux-ext4@vger.kernel.org>; Mon, 1 Feb 2010 22:50:15 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o11HKExb467130
	for <linux-ext4@vger.kernel.org>; Mon, 1 Feb 2010 22:50:15 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o11HKEWB029645
	for <linux-ext4@vger.kernel.org>; Tue, 2 Feb 2010 04:20:14 +1100
In-Reply-To: <7618835.18201265033304935.JavaMail.www@wsfrf1112>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon,  1 Feb 2010 15:08:24 +0100 (CET), <paul.chavent@fnac.net> wrote:
> Hi
> 
> I'am writing an application that write a stream of pictures of fixed size on a disk.
> 
> My app run on a self integrated gnu/linux (based on a 2.6.31.6-rt19 kernel).
> 
> My media is formated with
> 
> # mke2fs -t ext4 -L DATA -O large_file,^has_journal,extent -v /dev/sda3
> [...]
> 
> And it is mounted with 
> 
> # mount -t ext4 /dev/sda3 /var/data/
> EXT4-fs (sda3): no journal
> EXT4-fs (sda3): delayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs (sda3): mounted filesystem without journal
> 
> My app opens the file with "O_WRONLY | O_CREAT | O_TRUNC | O_SYNC | O_DIRECT" flags.
> 
> Each write takes ~4.2ms for 304K (it is very good since it is the write bandwidth of my hard drive). There is a write every 100ms.
> 
> But every exactly 646345728 bytes, the write takes ~46ms.

I guess that would be balance_dirty_pages starting to writeback the
delayed allocated pages. You can try if that changes by changing
/proc/sys/vm/dirty_ratio

-aneesh
