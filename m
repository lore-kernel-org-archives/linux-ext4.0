From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Coverity complaints about new crypto code
Date: Tue, 5 May 2015 08:41:06 -0400
Message-ID: <20150505124106.GA11805@thunk.org>
References: <20150505075436.GA11943@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45611 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbbEEMlJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 08:41:09 -0400
Content-Disposition: inline
In-Reply-To: <20150505075436.GA11943@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 05, 2015 at 09:54:36AM +0200, Jan Kara wrote:
> 
>   Coverity complains about the new ext4 crypto code. The complaint is that
> ext4_fname_crypto_alloc_buffer() and ext4_fname_crypto_namelen_on_disk()
> check for ctx being NULL but they dereference it before that check.
> I've checked and didn't find callers that would actually pass NULL into
> these functions so do we want to remove the unused check or move the
> dereference? I think it would be worth cleaning up just that we don't fall
> into the trap sometime later...

I'm going to be posting a performance patch shortly that drops
ext4_fname_crypto_ctx entirely (and with it those checks, obviously).
So that should take care of that.

Cheers,

						- Ted
