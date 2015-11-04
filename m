From: Jan Kara <jack@suse.com>
Subject: [PATCH 0/4] Output selection, improvements for ext4/001
Date: Wed,  4 Nov 2015 17:31:34 +0100
Message-ID: <1446654698-23577-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965625AbbKDQbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 11:31:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

the patch series below addresses some issues with test ext4/001. The first
patch is just a minor improvement to _filter_fiemap to work with older awk
programs. The second patch updates expected output of the test because it
slightly changes after punch hole fixes.

Patch 3 implements function which allows selecting different output file based
on mount options (or basically any feature string that's passed to the function
- e.g. selection based on fs blocksize can be easily done as well). Current
helper _link_out_file() could be implemented using this as well but for now
I left it alone. I think this feature can be useful when different mount
options change behavior of the filesystem and thus different output is
generated but we want to have test working all mount options.

Patch 4 uses the output selection function in ext4/001 to select different
output files based on mount options.

Comments welcome!

								Honza
