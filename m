From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] Output selection
Date: Tue, 24 Nov 2015 11:39:55 +0100
Message-ID: <1448361598-28438-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbbKXKkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2015 05:40:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.com>

Hello,

the patch series below addresses some issues with test ext4/001. First two
patches improve _link_out_file helper function to allow selection of output
(or in general linking any file when using _link_out_file_named() variant)
based on a feature string (usually mount options, fs features, operating
system) passed to the function (if no feature string is passed, the function
defaults to using "operating system name","mount options"). This feature
is useful when e.g. different mount options change behavior of the filesystem
and thus different output is generated but we want to have the test working
for all mount options.

Patch 3 uses the output selection function in ext4/001 to select different
output files based on mount options.

Comments welcome!

								Honza
--

Changes since v1:
* rebased on the current head of xfstests
* integrated output selection with _link_out_file and converted all tests
  using it

