From: "Alexander V. Lukyanov" <lav@netis.ru>
Subject: Re: PATCH: allow inode_readahead_blks=0
Date: Wed, 17 Nov 2010 10:48:54 +0300
Message-ID: <20101117074850.GA29191@proxy>
References: <20101116080546.GA7949@proxy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fire-ce0.netis.ru ([193.233.48.99]:59311 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab0KQHtY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 02:49:24 -0500
Received: from proxy.yar.ru (proxy.yar.ru [193.233.48.78])
	by fire.netis.ru (8.14.3/8.14.2) with ESMTP id oAH7muFh004113
	for <linux-ext4@vger.kernel.org>; Wed, 17 Nov 2010 10:48:58 +0300 (MSK)
Received: (from root@localhost)
	by proxy.yar.ru (8.14.4/8.14.2/Submit) id oAH7msHR029419
	for linux-ext4@vger.kernel.org; Wed, 17 Nov 2010 10:48:54 +0300
Content-Disposition: inline
In-Reply-To: <20101116080546.GA7949@proxy>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 11:05:46AM +0300, Alexander V. Lukyanov wrote:
> Currently the value 0 is disallowed, as it is not a power of 2.

BTW, the default value inode_readahead_blks=32 gives me troubles: it raises
load average and increases request latency on a busy squid server. I
explain it by random access to large number of files which are present in
the squid cache.

BTW2: the value of 0 should be allowed, it is explicitly used by the code:
                /*
                 * If we need to do any I/O, try to pre-readahead extra
                 * blocks from the inode table.
                 */
                if (EXT4_SB(sb)->s_inode_readahead_blks) {
			...
		}
-- 
   Alexander.
