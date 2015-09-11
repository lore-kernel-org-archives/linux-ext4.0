From: Chris Hunter <chris.hunter@yale.edu>
Subject: e2fsck discrepancy with debugfs stat ?
Date: Thu, 10 Sep 2015 23:03:57 -0400
Message-ID: <55F2449D.9090000@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vm-emlprdomg-09.its.yale.edu ([130.132.50.188]:54513 "EHLO
	vm-emlprdomg-09.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbbIKDD7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2015 23:03:59 -0400
Received: from localhost.localdomain ([172.28.220.38])
	(authenticated bits=0)
	by vm-emlprdomg-09.its.yale.edu (8.15.0.59/8.14.7) with ESMTPSA id t8B33vYQ016612
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2015 23:03:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
Are there scenarios where e2fsck will report a deleted/unused inode but 
debugfs is able to read the inode structure ?

Some details:
I am using lustre version of e2fsprogs (1.42.12.wc1). When I run e2fsck 
in nofix/dry-run mode on a blockdev, I receive errors about unused inodes.
eg)
 > $ e2fsck -nfv <DEV>
> e2fsck 1.42.12.wc1 (15-Sep-2014)
> Warning: skipping journal recovery because doing a read-only filesystem check.
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Entry '131249395' in /O/0/d19 (118843419) has deleted/unused inode 5671802.  Clear? no
etc...

However when I run command debugfs -c -R "stat /O/0/d19/131249395" 
<DEV>, I can retrieve inode contents. Further debugfs "dump" will 
successfully pull the contents (980 bytes) of the file entry.

thanks,
chris hunter
chris.hunter@yale.edu
