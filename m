From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Delayed alloc bug
Date: Wed, 03 Oct 2007 12:46:35 +0530
Message-ID: <470341D3.7020409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Alex Tomas <alex@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47356 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbXJCHRD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2007 03:17:03 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l937H263014614
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 17:17:02 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l937KZXf249226
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 17:20:35 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l937Gj7D009346
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 17:16:45 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We should actually get this error 

dd: writing to `myfile5': No space left on device



root@x300-qemu-image:~# mount /dev/hdc -t ext4dev -o delalloc,data=writeback /ext4
root@x300-qemu-image:/ext4# df -h . 
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdc               49M   46M   94K 100% /ext4
root@x300-qemu-image:/ext4# 
root@x300-qemu-image:/ext4# 
root@x300-qemu-image:/ext4# 
root@x300-qemu-image:/ext4# dd if=/dev/zero of=myfile 
34188+0 records in
34187+0 records out
17503744 bytes (18 MB) copied, 11.2724 seconds, 1.6 MB/s

root@x300-qemu-image:/ext4# df -h . 
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdc               49M   49M     0 100% /ext4
root@x300-qemu-image:/ext4# dd if=/dev/zero of=myfile5
49777+0 records in
49777+0 records out
25485824 bytes (25 MB) copied, 19.7667 seconds, 1.3 MB/s

root@x300-qemu-image:/ext4# df -h . 
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdc               49M   49M     0 100% /ext4
root@x300-qemu-image:/ext4# 
