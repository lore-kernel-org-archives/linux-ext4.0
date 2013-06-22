From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: remove while loop in
 mpage_map_and_submit_extent()
Date: Fri, 21 Jun 2013 23:48:32 -0400
Message-ID: <20130622034832.GA4727@thunk.org>
References: <1371477488-17722-1-git-send-email-tytso@mit.edu>
 <20130621163236.GN13932@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60190 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471Ab3FVDsg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 23:48:36 -0400
Content-Disposition: inline
In-Reply-To: <20130621163236.GN13932@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 06:32:36PM +0200, Jan Kara wrote:
>   This is not true. In case blocksize < pagesize and we were not able to
> map a full page, mpage_map_and_submit_buffers() changes mpd->map to point
> to the next extent inside the page that needs mapping. In that case we can
> take several iterations of the loop. Maybe this fact deserves a comment
> before the loop but there's a comment before the callsite of
> mpage_map_and_submit_buffers() which mentions that it will get us next
> extent to map and also the documentation of mpage_map_and_submit_buffers()
> explicitely tells that it can update mpd->map.

Ah, right.  Thanks, I missed where that was happening the first time I
was analyzing that function.

I've dropped this patch.

						- Ted
