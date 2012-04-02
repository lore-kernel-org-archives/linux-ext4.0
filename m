From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 0/2] ext4: warn on and address allocation of unreserved
 meta blocks in ENOSPC conditions
Date: Mon, 02 Apr 2012 11:14:08 -0400
Message-ID: <4F79C240.4020600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2DBPO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 11:14:26 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q32FEQOk027039
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 11:14:26 -0400
Received: from bfoster.bfoster (dhcp-187-76.bos.redhat.com [10.16.187.76])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q32FEP5U023434
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 11:14:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch set addresses the following errors reproduced during xfstests 270 against an ext2 fs (loop) with delayed allocation enabled:

Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): delayed block allocation failed for inode 14 at logical offset 64486 with max blocks 64 with error -28
Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This should not happen!! Data will be lost

270 ultimately fails with an inconsistent filesystem and requires an fsck to repair. The cause of the error is an underflow in ext4_da_update_reserve_space() due to an unreserved meta block allocation. I've split the fix into two technically independent changes and I'm sending this as an RFC because I'm relatively new to this code. Patch 1 adds a warning to detect the underflow condition and do an after the fact fix-up to prevent corruption. Patch 2 addresses the cause of this particular reservation failure. Further details are in the patch descriptions. 

I've run xfstests with these changes against ext2, ext3 and ext4. While I do reproduce a few other failures, these failures are also reproduced without these patches applied. Comments much appreciated.

Brian

[RFC PATCH 1/2] ext4: warn on delalloc md block allocation without reservation
[RFC PATCH 2/2] ext4: undo ei->i_da_metadata_calc_len increment if we fail to claim space
