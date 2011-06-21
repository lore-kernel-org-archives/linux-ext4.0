From: amir73il@users.sourceforge.net
Subject: [PATCH 0/4] ext4: reduce the size of inode.c
Date: Tue, 21 Jun 2011 12:39:24 +0300
Message-ID: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32881 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab1FUJjt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 05:39:49 -0400
Received: by wyb38 with SMTP id 38so2252726wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 02:39:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

inode.c has grown to almost 6000 lines and contains code for a wide variety
of functionalities.

This patch series reduces the file's size to under 4500 lines, by moving all
indirect inode specific implementations to a new file called indirect.c.
This convention is aligned with extent inode code being mostly in extents.c.

My own ulterior motive is that the snapshot patches were about to add another
~500 lines to inode.c, so now most of those lines will be added to indirect.c.

[PATCH 1/4] ext4: split ext4_ind_truncate from ext4_truncate
[PATCH 2/4] ext4: rename ext4_indirect_* funcs to ext4_ind_*
[PATCH 3/4] ext4: clone indirect.c file from inode.c
[PATCH 4/4] ext4: move ext4_ind_* functions from inode.c to indirect.c
