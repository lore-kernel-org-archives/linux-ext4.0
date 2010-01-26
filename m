From: Wu Fengguang <fengguang.wu@intel.com>
Subject: ext4_da_block_invalidatepages() question
Date: Tue, 26 Jan 2010 21:36:08 +0800
Message-ID: <20100126133608.GC25407@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0AZNgN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jan 2010 08:36:13 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

I noticed that ext4_da_block_invalidatepages() does pagevec_lookup()
without pagevec_release()/put_page(). Is that OK?

Thanks,
Fengguang
