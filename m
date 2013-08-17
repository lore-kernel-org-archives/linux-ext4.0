From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Move test whether extent to map can be
 extended to one place
Date: Sat, 17 Aug 2013 09:59:51 -0400
Message-ID: <20130817135951.GD30769@thunk.org>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
 <1375710744-29329-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44978 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab3HQN75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 09:59:57 -0400
Content-Disposition: inline
In-Reply-To: <1375710744-29329-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 03:52:21PM +0200, Jan Kara wrote:
> Currently the logic whether the current buffer can be added to an extent
> of buffers to map is split between mpage_add_bh_to_extent() and
> add_page_bufs_to_extent(). Move the whole logic to
> mpage_add_bh_to_extent() which makes things a bit more straightforward
> and make following i_size fixes easier.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
