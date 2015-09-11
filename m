From: Chris Hunter <chris.hunter@yale.edu>
Subject: Re: e2fsck discrepancy with debugfs stat ?
Date: Fri, 11 Sep 2015 08:39:04 -0400
Message-ID: <55F2CB68.1020507@yale.edu>
References: <55F2449D.9090000@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.yale.edu ([130.132.50.162]:50286 "EHLO
	vm-emlprdomg-04.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbbIKMjH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2015 08:39:07 -0400
Received: from localhost.localdomain ([172.28.220.43])
	(authenticated bits=0)
	by vm-emlprdomg-04.its.yale.edu (8.15.0.59/8.14.7) with ESMTPSA id t8BCd5eD028803
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2015 08:39:05 -0400
In-Reply-To: <55F2449D.9090000@yale.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To follow-up on my own question,

The "dry-run" e2fsck does not replay the ext journal. So my discrepancy, 
e2fsck reports a unused/deleted inode bug debugfs is able to access the 
inode & file data, could be due to uncommitted journal transactions.

regards,
chris hunter
chris.hunter@yale.edu

On 09/10/2015 11:03 PM, Chris Hunter wrote:
> Hi,
> Are there scenarios where e2fsck will report a deleted/unused inode but
> debugfs is able to read the inode structure ?
>
> Some details:
> I am using lustre version of e2fsprogs (1.42.12.wc1). When I run e2fsck
> in nofix/dry-run mode on a blockdev, I receive errors about unused inodes.
> eg)
>  > $ e2fsck -nfv <DEV>
>> e2fsck 1.42.12.wc1 (15-Sep-2014)
>> Warning: skipping journal recovery because doing a read-only
>> filesystem check.
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Entry '131249395' in /O/0/d19 (118843419) has deleted/unused inode
>> 5671802.  Clear? no
> etc...
>
> However when I run command debugfs -c -R "stat /O/0/d19/131249395"
> <DEV>, I can retrieve inode contents. Further debugfs "dump" will
> successfully pull the contents (980 bytes) of the file entry.
>
> thanks,
> chris hunter
> chris.hunter@yale.edu
