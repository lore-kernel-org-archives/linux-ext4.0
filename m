From: Johann Lombardi <johann@whamcloud.com>
Subject: MMP update
Date: Mon, 2 May 2011 10:11:19 +0200
Message-ID: <20110502081119.GA12403@granier.hd.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1EBILY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 04:11:24 -0400
Received: by wya21 with SMTP id 21so4026312wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2011 01:11:22 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs patch:
- use blk64_t instead of blk_t
- bump update interval to 5s

kernel patch:
- add more comments to struct mmp_struct
- remove unused EXT4_MMP_UPDATE_INTERVAL
- change check interval multiplier from 5 to 2
