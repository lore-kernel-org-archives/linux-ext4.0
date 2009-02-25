From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: double free of blocks occurred during online defrag
Date: Wed, 25 Feb 2009 15:39:52 +0900
Message-ID: <49A4E7B8.2040804@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53031 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZBYGkY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 01:40:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh,

When I remove the file that is running online defrag, the following error occurs
after closing the file descriptor:

Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8):
ext4_mb_release_inode_pa: free 2048, pa_free 1562
Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
double-free of inode 0's block 802817(bit 0 in group 98)
Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
double-free of inode 0's block 802818(bit 1 in group 98)
Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
double-free of inode 0's block 802819(bit 2 in group 98)
Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
double-free of inode 0's block 802820(bit 3 in group 98)
Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
double-free of inode 0's block 802821(bit 4 in group 98)
Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
double-free of inode 0's block 802822(bit 5 in group 98)

So, online defrag calls ext4_discard_preallocations() at the end of
ext4_defrag() to avoid double-free error.
However, above error hasn't occurred since applying your patch posted on Nov
6th, 2008 because this error is caused by the same reason of your report.
http://marc.info/?l=linux-ext4&m=122599787406193&w=4

What is the status of this patch?

Regards,
Kazuya Mio
