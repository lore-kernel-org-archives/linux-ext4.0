From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 0/13] Patches for e2fsprogs
Date: Tue, 24 Jul 2007 16:34:31 +0530
Message-ID: <1185275071.3789.65.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40545 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbXGXLDj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:03:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
	I am sending the patches for e2fsprogs as decided in the ext4 conf
call.
The patches are based on e2fsprogs-1.40.1. Some of these patches have
already been sent on the list before.

Patches to follow:
1/13 : iostats.
2/13 : Cleanup.
3/13 : Rpm Check.
4/13 : Allow regular files to be preallocated on-disk.
5/13 : Verify in-inode EA structure.
6/13 : Allow more than 32000 subdirectories [e2fsprogs part]
7/13 : Many inodes in filesystem.
8/13 : Config before command line.
9/13 : Adds two extended options and config file counterparts.
10/13: SLES10 patch which adds -m flag support to fsck
11/13: Uinitialised groups.
12/13: Expand inode size.
13/13: Improve e2fsck heuristics for detecting corrupted inodes.

Thanks,
Girish.
