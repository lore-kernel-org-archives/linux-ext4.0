From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] ext2, ext3: speed up file create workloads
Date: Tue, 07 Dec 2010 11:47:51 -0600
Message-ID: <4CFE7347.8030807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0LGRr6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Dec 2010 12:47:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The addition of 64k block capability in the rec_len_from_disk
and rec_len_to_disk functions added a bit of math overhead which
slows down file create workloads needlessly when the architecture
cannot even support 64k blocks, thanks to page size limits.

The directory entry checking can also be optimized a bit
by sprinkling in some unlikely() conditions to move the
error handling out of line.

These 2 patches speed up a bonnie++ file creation workload for
me by several percent on ext2 & ext3.

Thanks,
-Eric
