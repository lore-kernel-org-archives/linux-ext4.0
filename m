From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: More testing: 4x parallel 2G writes, sequential reads
Date: Thu, 08 Nov 2007 02:17:55 +0300
Message-ID: <473247A3.5020800@gmail.com>
References: <47323F73.5080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-2.sun.com ([192.18.6.24]:55052 "EHLO
	gmp-eb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbXKGXSK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2007 18:18:10 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id lA7NI8Hg014437
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 23:18:08 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JR500G01SJA3Q00@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Wed,
 07 Nov 2007 23:18:08 +0000 (GMT)
In-reply-to: <47323F73.5080708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

could you try to larger preallocation? like 512/1024/2048 blocks, please?

thanks, Alex

Eric Sandeen wrote:
> I tried ext4 vs. xfs doing 4 parallel 2G IO writes in 1M units to 4
> different subdirectories of the root of the filesystem:
> 
> http://people.redhat.com/esandeen/seekwatcher/ext4_4_threads.png
> http://people.redhat.com/esandeen/seekwatcher/xfs_4_threads.png
> http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_threads.png
> 
> and then read them back sequentially:
> 
> http://people.redhat.com/esandeen/seekwatcher/ext4_4_threads_read.png
> http://people.redhat.com/esandeen/seekwatcher/xfs_4_threads_read.png
> http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_read_threads.png
> 
> At the end of the write, ext4 had on the order of 400 extents/file, xfs
> had on the order of 30 extents/file.  It's clear especially from the
> read graph that ext4 is interleaving the 4 files, in about 5M chunks on
> average.  Throughput seems comparable between ext4 & xfs nonetheless.
> 
> Again this was on a decent HW raid so seek penalties are probably not
> too bad.
> 
> -Eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
