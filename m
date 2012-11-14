From: "George Spelvin" <linux@horizon.com>
Subject: debugfs feature request: dump sparse files as sparse.
Date: 13 Nov 2012 23:07:57 -0500
Message-ID: <20121114040757.16656.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:33807 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932427Ab2KNEH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 23:07:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When dumping a file with some messed-up block pointers, I discovered
that I had a huge, and fully allocated destination file.  (ls -s on the
dump displayed some very large number, even though the original file
only had about 8 blocks allocated.)

It wouldprobably make more sense to seek over the gaps to create a
sparse file.
