From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Wed, 20 Mar 2013 09:51:42 -0400
Message-ID: <20130320135142.GE12865@thunk.org>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <20130320132223.GD13294@quack.suse.cz>
 <20130320133751.GC12865@thunk.org>
 <20130320134226.GF13294@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54604 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab3CTNvo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 09:51:44 -0400
Content-Disposition: inline
In-Reply-To: <20130320134226.GF13294@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 20, 2013 at 02:42:26PM +0100, Jan Kara wrote:
>   Yeah, we can possibly rename the function or maybe even just inline it in
> ext4_evict_inode?

Good idea, I'll rename it to ext4_ioend_shutdown().  Given that the
rest of the logic is in page_io.c, it seemed better to leave that
function there than to inline it in ext4_evict_inode().

					- Ted
