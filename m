From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ext4_da_write_end() and copied == 0
Date: Mon, 12 Dec 2011 03:27:06 +0100
Message-ID: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1LLC1w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Dec 2011 21:27:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've been triggering ext4 troubles out of some experimental autonuma
code if I set knumad frequency rates very high.

The first patch looks fairly safe, but the second patch I've no idea
if it's correct and if damages stuff instead of fixing it, but clearly
it fixes the -EINVAL problem for me and it looks like to work fine now.

[PATCH 1/2] ext4: avoid hangs in ext4_da_should_update_i_disksize()
[PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock() wrong parameters

If you make alternate fixes for this let me know and I can test
them. I can reproduce both issues instantly.

Thanks,
Andrea
