From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 14 Sep 2008 09:47:11 -0400
Message-ID: <20080914134711.GA21746@infradead.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Theodore Ts'o <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYINNrN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2008 09:47:13 -0400
Content-Disposition: inline
In-Reply-To: <1221331767-16870-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 02:49:24PM -0400, Theodore Ts'o wrote:
> +* FIEMAP_EXTENT_NO_BYPASS
> +Direct access to the data in this extent is illegal or will have
> +undefined results.

This one is sitll misnamed and for sure utterly misdocumented.  Direct
access to the data is always illegal and has undefined results, and
programs that do it anyway (e.g. grub) are in really deep trouble.

I'm also not sure what happened to my request a few rounds ago to Cc
Michael Kerrisk on the thread.  He's been writing manpages for all
important kernel interfaces, and his review resulting from that has been
extremly useful.
