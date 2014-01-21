From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/6] miscellaneous e2fsprogs fixes
Date: Mon, 20 Jan 2014 22:21:38 -0800
Message-ID: <20140121062138.20507.60259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaAUGVn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 01:21:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are a few miscellaneous fixes for e2fsprogs-next.  Eventually
they'll end up in the patchbomb rollup, though for now I'm taking a
break on messing with e2fsprogs outside of pushing the rest of the
patchbomb into upstream.

The first couple of patches fix resource leaks and cleans up the Linux
kernel tests in mke2fs.

The next two patches fix some more errors in the punch routines that
resulted in premature exiting from the punch routine, or extent tree
breakage.

The final two patches deals with extent tree truncation problems when
there is an error while splitting an extent into three parts.

I've tested these e2fsprogs changes against the -next branch as of
1/16.  These days, I use an 8GB ramdisk and a 20T "disk" I constructed
out of dm-snapshot to test in an x64 VM.  The make check tests should
pass.

Comments and questions are, as always, welcome.

--D
