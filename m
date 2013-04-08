From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize ext4_end_io memory usage
Date: Mon, 8 Apr 2013 13:10:52 -0400
Message-ID: <20130408171052.GB4598@thunk.org>
References: <1364793468-1302-1-git-send-email-dmonakhov@openvz.org>
 <20130405093514.GA3848@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60339 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934523Ab3DHRKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 13:10:54 -0400
Content-Disposition: inline
In-Reply-To: <20130405093514.GA3848@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 05, 2013 at 11:35:14AM +0200, Jan Kara wrote:
> On Mon 01-04-13 09:17:48, Dmitry Monakhov wrote:
> > ext4_end_io->pages array has is used only for buffered writes and usless
> > in case of DIO. This patch allow us to save 1K for each DIO request.
>   I have actually a more complete solution to this in my patch queue -
> there isn't any need to reference pages from io_end after my patches.
> Hopefully I'll be able to send things out later today...

Hi Jan,

Did you have a chance to send out your patches?

Thanks,

						- Ted
