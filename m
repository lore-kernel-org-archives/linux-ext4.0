From: marcin.slusarz@gmail.com
Subject: [PATCH 0/3] byteorder: introduce le32_add_cpu & friends to core
Date: Sat,  5 Jan 2008 16:36:19 +0100
Message-ID: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
	OCFS2-devel <ocfs2-devel@oss.oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, xfs-masters@oss.sgi.com,
	Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:13146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbYAEPer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2008 10:34:47 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3845935fga.17
        for <linux-ext4@vger.kernel.org>; Sat, 05 Jan 2008 07:34:45 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

This patchset moves le*_add_cpu and be*_add_cpu functions from OCFS2 to core
header (1st), converts ext3 filesystem to this API (2nd) and replaces
XFS different named functions with new ones (3rd).

There are many places where these functions will be useful.
Just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/
Patch for ext3 is an example how conversions will probably look like.

ps: this patchset depends on http://lkml.org/lkml/2007/12/25/35 (which is
    in ocfs2 git tree, branches: trivial, ALL)

Marcin Slusarz
