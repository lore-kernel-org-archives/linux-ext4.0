From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix fallocate to update the file size in each
	transaction.
Date: Tue, 11 Mar 2008 11:25:55 +0530
Message-ID: <20080311055555.GB8108@skywalker>
References: <1205214445-8328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53336 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYCKGXi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 02:23:38 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2B5umL7013631
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 16:56:48 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B5u9Jn3141720
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 16:56:09 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2B5u9oL024504
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 16:56:09 +1100
Content-Disposition: inline
In-Reply-To: <1205214445-8328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2008 at 11:17:25AM +0530, Aneesh Kumar K.V wrote:
> ext4_fallocate need to update file size in each transaction. Otherwise
> ife we crash the file size won't be updated. We were also not marking
> the inode dirty after updating file size before. Also when we try to
> retry allocation due to ENOSPC make sure we reset the variable ret so
> that we actually do a retry.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Tested fallocate series with a modifed fsx-linux 

/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -r 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -r 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -b 1000 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -s 1 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096  -t 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 2048  -t 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096  -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048  -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -A -O -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -A -O -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -A -S 0 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -A -S 2000 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -W -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -W -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -A -R -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -A -R -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -l 500000 -r 4096 -w 4096 -Z -R -W -A  -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 1024 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 2048 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 4096 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 8192 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 1024 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 2048 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 4096 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 8192 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 1024 -A -l 500000 -r 2048 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 2048 -A -l 500000 -r 512 -t 2048 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 4096 -A -l 500000 -r 512 -t 4096 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 8192 -A -l 500000 -r 1024 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 -A -l 500000 -r 4096 -t 4096 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 -A -l 500000 -r 2048 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -A -l 500000 -r 512 -t 4096 -w 1024 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 -r 4096 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -r 2048 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 1024 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 2048 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 4096 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 8192 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile1 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 -A -l 500000 -r 4096 -t 2048 -w 2048 /mnt/tmp/junkfile2 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile3 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile4 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 32768 -A -l 500000 -r 4096 -t 2048 -w 2048 /mnt/tmp/junkfile5 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 128000 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile6 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -A /mnt/tmp/junkfile7 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 100000 -A /mnt/tmp/junkfile8 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 100000 -A /mnt/tmp/junkfile9 &
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 8192 -A -l 500000 -r 1024 -t 2048 -w 1024 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 1 -N 10000 -o 16384 -A -l 500000 -r 2048 -t 4096 -w 1024 -Z -R -W /mnt/tmp/junkfile

/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -n -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -r 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -r 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -b 1000 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -s 1 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096  -t 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 2048  -t 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096  -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048  -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -A -O -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -A -O -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -A -S 0 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -A -S 2000 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -W -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -W -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -A -R -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -A -R -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -l 500000 -r 4096 -w 4096 -Z -R -W -A  -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -A -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 1024 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 2048 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 4096 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 8192 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 1024 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 2048 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 4096 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 8192 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -A /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 1024 -A -l 500000 -r 2048 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 2048 -A -l 500000 -r 512 -t 2048 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 4096 -A -l 500000 -r 512 -t 4096 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 8192 -A -l 500000 -r 1024 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 -A -l 500000 -r 4096 -t 4096 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 -A -l 500000 -r 2048 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -A -l 500000 -r 512 -t 4096 -w 1024 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 -r 4096 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -r 2048 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 1024 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 2048 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 4096 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 8192 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 -l 500000 -r 4096 -t 2048 -w 2048 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile1 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 -A -l 500000 -r 4096 -t 2048 -w 2048 /mnt/tmp/junkfile2 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile3 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile4 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 32768 -A -l 500000 -r 4096 -t 2048 -w 2048 /mnt/tmp/junkfile5 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 128000 -A -l 500000 -r 4096 -t 4096 -w 4096 /mnt/tmp/junkfile6 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -A /mnt/tmp/junkfile7 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 100000 -A /mnt/tmp/junkfile8 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 100000 -A /mnt/tmp/junkfile9 &
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 8192 -A -l 500000 -r 1024 -t 2048 -w 1024 -Z -R -W /mnt/tmp/junkfile
/usr/local/fsx-linux/bin/fsx-linux -x 2 -N 10000 -o 16384 -A -l 500000 -r 2048 -t 4096 -w 1024 -Z -R -W /mnt/tmp/junkfile



--- /home/kvaneesh/tmp/autotest/client/tests/fsx/src/fsx-linux.c	2007-09-12 20:56:25.000000000 +0530
+++ fsx-linux.c	2008-03-09 17:03:56.000000000 +0530
@@ -114,10 +114,12 @@
 int     mapped_writes = 1;              /* -W flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
 int	aio = 0;
+int     prealloc = 0;			/* -x [0|1]run test with prealloc default
+					   disabled */
 
 #ifdef AIO
 int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
 #define READ 0
 #define WRITE 1
@@ -849,10 +851,11 @@
 	-P: save .fsxlog and .fsxgood files in dirpath (default ./)\n\
 	-S seed: for random # generator (default 1) 0 gets timestamp\n\
 	-W: mapped write operations DISabled\n\
         -R: read() system calls only (mapped reads disabled)\n\
         -Z: O_DIRECT (use -R, -W, -r and -w too)\n\
+	-x: run test after preallocating the area (1|2) 2 to not update size.\n\
 	fname: this filename is REQUIRED (no default)\n");
 	exit(90);
 }
 
 
@@ -973,12 +976,12 @@
 	goodfile[0] = 0;
 	logfile[0] = 0;
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:AD:LN:OP:RS:WZ"))
-	       != EOF)
+	while ((ch = getopt(argc, argv,
+			"b:c:dfl:m:no:p:qr:s:t:w:AD:LN:OP:RS:WZx:")) != EOF)
 		switch (ch) {
 		case 'b':
 			simulatedopcount = getnum(optarg, &endp);
 			if (!quiet)
 				fprintf(stdout, "Will begin at operation %ld\n",
@@ -1098,10 +1101,15 @@
 				fprintf(stdout, "mapped writes DISABLED\n");
 			break;
 		case 'Z':
 			o_direct = O_DIRECT;
 			break;
+		case 'x':
+			prealloc = getnum(optarg, &endp);
+			if (prealloc <= 0)
+				usage();
+			break;
 		default:
 			usage();
 			/* NOTREACHED */
 		}
 	argc -= optind;
@@ -1128,10 +1136,43 @@
 		O_RDWR|(lite ? 0 : O_CREAT|O_TRUNC)|o_direct, 0666);
 	if (fd < 0) {
 		prterr(fname);
 		exit(91);
 	}
+#define FALLOC_FL_KEEP_SIZE	0x01
+#ifdef __i386__
+#define __NR_fallocate          324
+	loff_t offset, maxlen;
+	offset = 0;
+	maxlen = maxfilelen;
+	if (prealloc == 1) {
+		if (syscall(__NR_fallocate, fd, 0, offset, maxlen) < 0) {
+			prterr(fname);
+			exit(97);
+		}
+	} else if (prealloc == 2) {
+		if (syscall(__NR_fallocate, fd, FALLOC_FL_KEEP_SIZE, offset, maxlen) < 0) {
+			prterr(fname);
+			exit(97);
+		}
+	}
+#elif defined (__powerpc__)
+#define __NR_fallocate          309
+	/* Work only with 32 bit user space */
+	unsigned int maxlen = maxfilelen;
+	if (prealloc == 1) {
+		if (syscall(__NR_fallocate, fd, 0, 0, 0, 0, maxlen) < 0) {
+			prterr(fname);
+			exit(97);
+		}
+	} else if (prealloc == 2) {
+		if (syscall(__NR_fallocate, fd, FALLOC_FL_KEEP_SIZE, 0, 0, 0, maxlen) < 0) {
+			prterr(fname);
+			exit(97);
+		}
+	}
+#endif
 	strncat(goodfile, fname, 256);
 	strcat (goodfile, ".fsxgood");
 	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
 	if (fsxgoodfd < 0) {
 		prterr(goodfile);
