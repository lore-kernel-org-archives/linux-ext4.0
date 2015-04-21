From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Subject: bigalloc cluster size
Date: Tue, 21 Apr 2015 16:31:20 +0300
Message-ID: <55365128.206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27292 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbbDUN2R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2015 09:28:17 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t3LDSGpC019565
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 13:28:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t3LDSGnH031395
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 13:28:16 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t3LDSFeM003551
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 13:28:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I've noted that valid cluster size is not limited by 256M according to 
"mke2fs" manual:

"-C  cluster-size
Specify the size of cluster in bytes for filesystems using the bigalloc 
feature.  Valid cluster-size values are from 2048 to 256M bytes per 
cluster."

but actually it's limited by 512M:

"[root@fedora ~]# mkfs.ext4 -O bigalloc -C 512m /dev/sdb
mke2fs 1.43-WIP (29-Mar-2015)
/dev/sdb contains a ext4 file system
     created on Tue Apr 21 15:30:27 2015
Proceed anyway? (y,n) yes

Warning: the bigalloc feature is still under development
See https://ext4.wiki.kernel.org/index.php/Bigalloc for more information

Creating filesystem with 2097152 4k blocks and 16 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

[root@fedora ~]# mkfs.ext4 -O bigalloc -C 1024m /dev/sdb
mkfs.ext4: invalid cluster size - 1024m"

(running on vbox Fedora x86_64, latest e2fsprogs, kernel 4.0.0-rc5)

Is it documentation issue?

Thanks,
Alexander Tsvetkov
