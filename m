From: Alexander Inyukhin <shurick@sectorb.msk.ru>
Subject: noacl and nouser_xattr deprecation warning
Date: Wed, 7 Oct 2015 15:47:32 +0300
Message-ID: <20151007124732.GA17392@shurick.grid.su>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.imec.msu.ru ([93.180.3.203]:38083 "EHLO imap.imec.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbJGMxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Oct 2015 08:53:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by imap.imec.msu.ru (Postfix) with ESMTP id C1479C2AF
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2015 15:47:35 +0300 (MSK)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

noacl and nouser_xattr mount options produce an annoying
and misleading warning about their removal "by 3.5".
It is 4.2 already, does the patch f70486055 still actual?

The options themselves are very useful.
