From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH 0/3] ext4: inode preferred block allocation
Date: Wed, 14 Apr 2010 17:17:33 +0900
Message-ID: <4BC57A1D.9080105@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63453 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0DNIYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Apr 2010 04:24:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We implemented new two ioctls to allocate preferred blocks using inode PA.
The old implementation idea is the following (b).
http://marc.info/?l=linux-ext4&m=124962738211206&w=4

One is EXT4_IOC_CONTROL_PA that is to create or discard inode PA, and the
other is EXT4_IOC_GET_PA that is to get inode PA information.

1. EXT4_IOC_CONTROL_PA

   EXT4_IOC_CONTROL_PA is used to create new inode PA, or to discard all inode
   PAs in the target inode. This means that we will be able to allocate
   the blocks we want.
   We have a plan to add a new feature to e4defrag with these ioctls. This
   feature improves read throughput when we read the files in the same
   directory by reallocating target files near their parent directory.

2. EXT4_IOC_GET_PA

   EXT4_IOC_GET_PA is used to get inode PA information.

Moreover, when we create an inode PA, ext4_mb_new_inode_pa() merges
contiguous inode PA if possible.

This patch set consists of the following three patches. They can be applied to
the ext4 patch queue:
commit: 1dea5b6f540ad056d51d11cda71fa757cb44cbc4

[RFC][PATCH 0/3] ext4: inode preferred block allocation
[RFC][PATCH 1/3] ext4: add EXT4_IOC_CONTROL_PA to create/discard inode PA
[RFC][PATCH 2/3] ext4: sort and merge inode PA
[RFC][PATCH 3/3] ext4: add EXT4_IOC_GET_PA to get inode PA information

Any comments are very welcome.

Best regards,
Kazuya Mio

