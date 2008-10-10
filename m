From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 0/4] ext4/jbd2: possible filesystem corruption fixes
Date: Fri, 10 Oct 2008 17:47:06 +0900
Message-ID: <48EF168A.4000705@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56992 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYJJIrT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 04:47:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch set fixes ext4 fs corruption problems caused by
transient I/O error.  The ext3/jbd version is already in the
current -mm.

Here is the ext3/jbd version:
http://kerneltrap.org/mailarchive/linux-kernel/2008/7/24/2661724

This patch set consists of following 4 patches:

[PATCH 1/4] jbd2: abort when failed to log metadata buffers
[PATCH 2/4] jbd2: fix error handling for checkpoint io
[PATCH 3/4] ext4: add checks for errors from jbd2
[PATCH 4/4] jbd2: don't dirty original metadata buffer on abort

In the ext3/jbd version, PATCH 2/4 had a problem and I fixed it
with an additional patch later.  This time PATCH 2/4 includes
that fix.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


