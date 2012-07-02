From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dead/wrong code in ext3/4_releasepage()
Date: Mon, 2 Jul 2012 14:17:20 -0400
Message-ID: <20120702181720.GD5795@thunk.org>
References: <4FEDDD63.4000800@ya.ru>
 <20120702170959.GJ6679@quack.suse.cz>
 <4FF1D712.3060402@ya.ru>
 <20120702173326.GL6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Perepechko <anserper@ya.ru>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54032 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab2GBSRW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 14:17:22 -0400
Content-Disposition: inline
In-Reply-To: <20120702173326.GL6679@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 02, 2012 at 07:33:26PM +0200, Jan Kara wrote:
>   Hi,
> 
> On Mon 02-07-12 21:14:58, Andrew Perepechko wrote:
> > So you think the correct fix would be to remove the check completely
> > since every try_to_release_page() caller is obliged to perform the
> > page_has_private() check?
>   Yes, I think that would be reasonable. XFS already relies on this so
> it should be safe.

Andrew, can you send me a patch?

Thanks,

							- Ted
