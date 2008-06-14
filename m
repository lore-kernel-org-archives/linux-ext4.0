From: Gary Hawco <ghawco@cox.net>
Subject: How to switch ext4 to ordered_data mode
Date: Sat, 14 Jun 2008 00:39:35
Message-ID: <3.0.6.32.20080614003935.02423cb8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:44040 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYFNH5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jun 2008 03:57:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

I notice that ext4dev defaults to data=writeback mode. This is in contrast
to ext3 which uses ordered data mode. Tune2fs from git does not seem to be
able to change this using "tune2fs -o ^journal_data_writeback /dev/sdaX"
followed by "tune2fs -o journal_data_ordered /dev/sdaX.

Is this change intentional or a not yet worked out bug?

Thanks,
Gary Hawco

