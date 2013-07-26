From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] destroy ext4_es_cachep on module unload
Date: Fri, 26 Jul 2013 15:22:40 -0400
Message-ID: <20130726192240.GA7247@thunk.org>
References: <51F1DCCE.6060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45421 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3GZTWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jul 2013 15:22:45 -0400
Content-Disposition: inline
In-Reply-To: <51F1DCCE.6060405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 25, 2013 at 09:19:58PM -0500, Eric Sandeen wrote:
> Without this, module can't be reloaded.
> 
> [  500.521980] kmem_cache_sanity_check (ext4_extent_status): Cache name already exists.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
