From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH 0/2] ext3 HACKs
Date: Tue, 14 Jul 2009 17:05:48 +0300
Message-ID: <20090714140548.26116.2919.sendpatchset@ahunter-tower>
Cc: Artem Bityutskiy <artem.bityutskiy@nokia.com>,
	linux-ext4@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>
To: Stephen Tweedie <sct@redhat.com>, Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52439 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbZGNOFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 10:05:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

We are using linux 2.6.28 and we have a situation where ext3
can take 30-60 seconds to mount.

The cause is the underlying device has extremely poor random
write speed (several orders of magnitude slower than sequential
write speed), and journal recovery can involve many small random
writes.

To alleviate this situation somewhat, I have two moderately ugly
hacks:
	HACK 1: ext3: mount fast even when recovering
	HACK 2: do I/O read requests while ext3 journal recovers

HACK 1 uses a I/O barrier in place of waiting for recovery I/O to be
flushed.

HACK 2 crudely throws I/O read requests to the front of the dispatch
queue until the I/O barrier from HACK 1 is reached.

If you can spare a moment to glance at these hacks and notice
any obvious flaws, or suggest a better alternative, it would be
greatly appreciated.

Regards
Adrian Hunter

