From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] ext2: Preparation to remove BKL
Date: Mon, 12 Apr 2010 23:01:29 +0200
Message-ID: <20100412210127.GE8285@nowhere>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41975 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0DLVBf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 17:01:35 -0400
Content-Disposition: inline
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 12, 2010 at 10:41:40PM +0200, Jan Blunck wrote:
> In this series I've collected the patches that prepare ext2 for BKL removal.
> It consist mostly of cleanups and additionally introduces a spinlock to protect
> some of the superblock's fields against concurrent access. I've addressed the
> feedback kindly provided by Ogawa-san by moving the ext2_write_super() out of
> ext2_setup_super().
> 
> These patches have been part of the BKL removal series that I have posted in
> November 2009 already. Since this is more than just removing the usage of the
> big lock I repost it separately for inclusion. This series, at least the last
> patch that includes the s_lock, needs to be merged before Frederics bkl-removal
> branch, if he merges the rest of my patches there.


It looks like this is all about .35 material.

This is going to be hard to have a separate tree to pushdown/remove
the bkl in the mount path if it depends on the ext2 tree.

What about putting that with the fs bkl removal tree? Would that conflict
with other changes in the ext2 tree?

Thanks.

