From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCHES/RFC v1.0.12] e2fsprogs: Next3 patch series
Date: Tue, 20 Jul 2010 18:16:01 +0300
Message-ID: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33333 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab0GTPP3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:15:29 -0400
Received: by wwj40 with SMTP id 40so966783wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:15:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

The following patches apply and tested on e2fsprogs master branch (on July 20).

Please help me review and push these patches upstream.

Thanks,
Amir.

[PATCH 01/12] e2fsprogs: Next3 on-disk format changes
[PATCH 02/12] e2fsprogs: Create a big journal for Next3
[PATCH 03/12] e2fsprogs: Create/check exclude inode for Next3
[PATCH 04/12] e2fsprogs: Next3 snapshot control with chattr/lsattr -X
[PATCH 05/12] e2fsprogs: Avoid offline modifications to a file system with snapshots
[PATCH 06/12] e2fsprogs: Cleanup Next3 snapshot list when removing has_snapshot feature
[PATCH 07/12] e2fsprogs: Check Next3 exclude bitmap on fsck
[PATCH 08/12] e2fsprogs: Check Next3 snapshot list on fsck
[PATCH 09/12] e2fsprogs: Delete all snapshots on fsck -x
[PATCH 10/12] e2fsprogs: Map maximum filesystem size with a single snapshot file
[PATCH 11/12] e2fsprogs: Dump Next3 message buffer on fsck
[PATCH 12/12] e2fsprogs: Migrate old to new on-disk format


