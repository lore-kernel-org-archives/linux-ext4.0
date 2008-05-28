From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Silence warnings about non-uptodate buffers
Date: Wed, 28 May 2008 23:56:08 +0200
Message-ID: <12120117733479-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54449 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbYE1V4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 17:56:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

the series of patches below gets rid of warning messages in mark_buffer_dirty()
when underlying block device becomes unavailable. Andrew, would you merge them
please?

								Honza
