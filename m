From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v1 0/2] ext4: Shut down block groups when damage is detected,
 part 2
Date: Thu, 26 Sep 2013 17:03:21 -0700
Message-ID: <20130927000321.17889.68250.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3I0AD0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Sep 2013 20:03:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patchset adds in a few things that weren't included in the original block
group shutdown patches.

The first prevents corrupt block groups from contributing to the free block
summary count, since by definition corrupt block groups have no free blocks.

The second patch performs a quick sanity check of bitmap and inode table block
numbers when loading them in from disk.  These are the same checks that are
done at mount time; this patch guards against either deliberate sabotage or
memory corruption.  Since we're about to do a slow disk read anyway, we might
as well take the time to double check for obvious brokenness.

This patchset has been tested (albeit lightly) against 3.12-rc2 on x64.

Comments and questions are, as always, welcome.

--D
