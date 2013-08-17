From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: Simplify truncation code in ext4_setattr()
Date: Sat, 17 Aug 2013 10:08:28 -0400
Message-ID: <20130817140828.GF30769@thunk.org>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
 <1375710744-29329-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44997 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab3HQOIa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 10:08:30 -0400
Content-Disposition: inline
In-Reply-To: <1375710744-29329-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 03:52:23PM +0200, Jan Kara wrote:
> Merge conditions in ext4_setattr() handling inode size changes, also
> move ext4_begin_ordered_truncate() call somewhat earlier because it
> simplifies error recovery in case of failure. Also add error handling in
> case i_disksize update fails.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied with one minor whitespace fixup.

							- Ted
