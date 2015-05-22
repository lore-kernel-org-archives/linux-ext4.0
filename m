From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] e2fsprogs: Support for orphan file feature
Date: Fri, 22 May 2015 13:28:53 +0200
Message-ID: <1432294137-26078-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161006AbbEVL3B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 07:29:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BB992AD31
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 11:29:00 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this is support orphan file feature in e2fsprogs. mke2fs and tune2fs support
should be fine, e2fsck support still has bugs so use with care. I'm posting
this mainly so that people can easily create filesystem with orphan file
feature for testing the kernel patches.

								Honza
