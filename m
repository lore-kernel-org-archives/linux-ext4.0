From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/7] ext2: Preparation to remove BKL (v2)
Date: Wed, 14 Apr 2010 15:50:48 +0200
Message-ID: <20100414135048.GE3616@quack.suse.cz>
References: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50848 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab0DNNum (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 09:50:42 -0400
Content-Disposition: inline
In-Reply-To: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-04-10 14:38:32, Jan Blunck wrote:
> This is a series of patches in preparation to the removal of the big kernel
> lock from ext2. It consists mostly of cleanup patches to later introduce a
> spinlock to protect some of the superblock's fields against concurrent access.
> With the spinlock in place we don't need to use the big kernel lock anymore.
> 
> This series has been part of the BKL removal patches that I have posted in
> November 2009 already. I've addressed the feedback kindly provided by Ogawa-san
> by moving the ext2_write_super() out of ext2_setup_super().
> 
> Changes since v1:
> - fix typo when setting MS_RDONLY
> - take s_lock when setting EXT2_FEATURE_COMPAT_EXT_ATTR
> - fold ext2_commit_super() into ext2_sync_super()
> - include BKL removal patch
  OK, I've merged all the patches into my for_testing branch. When it
survives some testing, I'll push them to for_next branch to be pushed
for 2.6.35.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
