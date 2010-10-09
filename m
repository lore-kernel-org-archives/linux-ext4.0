From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused ext4_sb_info members
Date: Sat, 9 Oct 2010 19:18:59 -0400
Message-ID: <20101009231859.GF11237@thunk.org>
References: <4CA0CE3C.7050903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45920 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0JIXTA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 19:19:00 -0400
Content-Disposition: inline
In-Reply-To: <4CA0CE3C.7050903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 27, 2010 at 12:02:52PM -0500, Eric Sandeen wrote:
> Not that these take up a lot of room, but the structure is long enough
> as it is, and there's no need to confuse people with these various
> undocumented & unused structure members...
> 
> Signed-off-by: Eric Sandeen <sandeen@redaht.com>

Added to the ext4 patch queue, thanks.

					- Ted
