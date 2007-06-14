From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 0/6] inode version updated patches
Date: Thu, 14 Jun 2007 21:26:11 +0530
Message-ID: <1181836571.7779.42.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32981 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXFNP4F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 11:56:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I have updated the inode version patches and below are the details:

64-bit-i_version.patch which only replaces the 32-bit i_version field in
the generic inode with a 64-bit i_version field. The VFS-level updates
of the inode version are still in the i_version_update_vfs.patch and
this patch has been moved to the bottom of the patch series.

ext4_i_version_hi_2.patch was still using ei->i_fs_version instead of
inode->i_version. I have corrected this patch.

Also there were whitespace problems in i_version_hi.patch.

I am also attaching a ext4_no_version.patch which adds a "noversion"
mount option to disable inode version updates.

I am not sure why i_version needs to be updated in VFS since it is being
updated in ext4_mark_iloc_dirty().

Well, these are lots of small patches and I am sending them separately
so that they can be applied and commented upon easily.

Thanks,
Kalpak.
