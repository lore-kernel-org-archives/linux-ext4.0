From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 0/10] Add SipHash-2-4 directory hashing support
Date: 23 Sep 2014 06:02:14 -0400
Message-ID: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:23182 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754383AbaIWKCR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:02:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This has survived some very basic testing (creating a test file system,
placing 100K files in the root directory, unmount, remount, finding
a few, e2fsck, debugfs...), so I'll throw it out here for the usual
style kibitzing.

Note that the first 5 patches in the series are to the Linux kernel
tree, while the second 5 are to the e2fsprogs tree.  Is there a
convention for that sort of thing?
