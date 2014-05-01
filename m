From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/5] miscellaneous kernel ext4 fixes
Date: Thu, 01 May 2014 16:17:20 -0700
Message-ID: <20140501231720.892.58712.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaEAXR0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:17:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are a few patches that have been sitting around in my tree for a
while.  They're not interdependent; the first three are simple
bugfixes.  The last one introduces ext5, which reduces our testing
matrix by requiring a fairly large set of features and eliminating
most mount options.  True, not all the features are stable or ready
for production yet, but six years after ext4 we have a bunch of new
features ready for wider testing.

I've tested these kernel changes against 3.15-rc3.  These days, I use
several VMs, each with 8GB ramdisks to test with; the test process is
checkpatch > metadata checksum tests > xfstests.

Comments and questions are, as always, welcome.

--D
