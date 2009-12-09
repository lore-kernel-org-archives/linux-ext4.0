From: tytso@mit.edu
Subject: Re: [PATCH 2/3] ext4: Fix data / filesystem corruption when write
 fails to copy data
Date: Tue, 8 Dec 2009 21:26:22 -0500
Message-ID: <20091209022622.GX27692@thunk.org>
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
 <1259781409-31318-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38426 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZLIC0W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 21:26:22 -0500
Content-Disposition: inline
In-Reply-To: <1259781409-31318-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 02, 2009 at 08:16:48PM +0100, Jan Kara wrote:
> When ext4_write_begin fails after allocating some blocks or
> generic_perform_write fails to copy data to write, we truncate blocks already
> instantiated beyond i_size. Although these blocks were never inside i_size, we
> have to truncate pagecache of these blocks so that corresponding buffers get
> unmapped. Otherwise subsequent __block_prepare_write (called because we are
> retrying the write) will find the buffers mapped, not call ->get_block, and
> thus the page will be backed by already freed blocks leading to filesystem and
> data corruption.

Added to the ext4 patch queue.

						- Ted
