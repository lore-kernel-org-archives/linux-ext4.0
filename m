From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: make barrier options consistent with ext4
Date: Mon, 3 May 2010 18:36:09 +0200
Message-ID: <20100503163609.GD3470@quack.suse.cz>
References: <4BDB00BE.7040600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063Ab0ECQgK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 May 2010 12:36:10 -0400
Content-Disposition: inline
In-Reply-To: <4BDB00BE.7040600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 30-04-10 11:09:34, Eric Sandeen wrote:
> ext4 was updated to accept barrier/nobarrier mount options
> in addition to the older barrier=0/1.  The barrier story
> is complex enough, we should help people by making the options
> the same at least, even if the defaults are different.
> 
> This patch allows the barrier/nobarrier mount options for ext3,
> while keeping nobarrier the default.
> 
> It also unconditionally displays barrier status in show_options,
> and prints a message at mount time if barriers are not enabled,
> just as ext4 does.
  Thanks. Added to my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
