From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: per inode fsync optimization question
Date: Wed, 03 Apr 2013 18:21:46 +0400
Message-ID: <8738v7r8xx.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54153 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3DCOV7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 10:21:59 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so1628036lbh.21
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 07:21:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


inode store i_sync_tid and i_datasync_tid  in order to optimize journal
flushes and wait for commits only when necessary, but
fields are declared as tid_t(not atomic_t as it done in ext3) so we
have not synchronization between readers and writers, so gcc and cpu
is allowed to perform prefetch, cache and other stuff.
Looks like a bug, right?


