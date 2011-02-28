From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 19:09:50 +0100
Message-ID: <20110228180950.GD20805@quack.suse.cz>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1B1SJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 13:09:52 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-02-11 22:40:19, Amir Goldstein wrote:
> Orphan cleanup is currently executed even on readonly mount.
> It deletes inodes and frees blocks, which could be very bad for some
> RO_COMPAT features, HAS_SNAPSHOT to name one.
> 
> Now the damage is done, because current stock kernels may
> corrupt future fs with readonly compatible features,
> when doing orphan cleanup.
> 
> This patch skips the orphan cleanup if readonly compatible features
> would prevent the fs from being mounted (or remounted) readwrite.
  Thanks Amir. I actually took the version Ted committed to ext4 and ported
it for ext3. Anyway, the patch is in my tree.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
