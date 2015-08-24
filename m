From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: ext4 metadata corruption bug bites again
Date: Mon, 24 Aug 2015 15:14:06 +0200
Message-ID: <20150824131406.GE20572@dot.dmz.freshdot.net>
References: <20150821094534.GD20572@dot.dmz.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:36189 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbbHXNwS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2015 09:52:18 -0400
Content-Disposition: inline
In-Reply-To: <20150821094534.GD20572@dot.dmz.freshdot.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Sander Smeenk (ssmeenk@freshdot.net):

> | [000d00h01m43s] EXT4-fs error (device vdb): ext4_mb_generate_buddy:757:
> |   group 79842, block bitmap and bg descriptor inconsistent: 10073 vs 10071
> |   free clusters
> | [000d00h01m43s] Aborting journal on device vdb-8.

Today it went again:

[000d05h26m50s] EXT4-fs error (device vdb): ext4_mb_generate_buddy:757: group 45706, block bitmap and bg descriptor inconsistent: 1769 vs 1768 free clusters
[000d05h26m50s] Aborting journal on device vdb-8.
[000d05h26m50s] EXT4-fs (vdb): Remounting filesystem read-only
[000d05h16m42s] EXT4-fs (vdb): pa ffff88003527fc30: logic 331144, phys.  1363269705, len 511
[000d05h16m42s] EXT4-fs error (device vdb): ext4_mb_release_inode_pa:3772: group 41603, free 511, pa_free 507
[000d05h16m42s] EXT4-fs (vdb): pa ffff88002ed668f0: logic 286160, phys.  1362907136, len 511
[000d05h16m42s] EXT4-fs error (device vdb): ext4_mb_release_inode_pa:3772: group 41592, free 511, pa_free 503

I'm now running 3.19.8-ckt4 with WARN_ON(1); inserted in the above
mentioned error situations.

-Sndr.
-- 
| Do pilots take crash-courses?
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
