From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: clean up ext4_remove_blocks() return
Date: Thu, 13 Jul 2017 18:33:51 -0400
Message-ID: <20170713223351.iqt4owygisqnm6wm@thunk.org>
References: <20170713151703.GA6383@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47964 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdGMWdy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 18:33:54 -0400
Content-Disposition: inline
In-Reply-To: <20170713151703.GA6383@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 11:17:03AM -0400, Eric Whitney wrote:
> ext4_remove_blocks() never returns anything other than 0, signifying
> success.  Convert the function to void type to make this immediately
> obvious at the call site.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Actually, what we should do is to bubble errors up from
ext4_remove_blocks to the callers of ext4_ext_rm_leaf().  At the
moment it doesn't return any errors, but eventually we should be
returning errors all the way up to ext4 truncate.

The reason why it's a little tricky is it's more than just not
deleting the call to ext4_std_error() and then returning error up to
the caller.  We need to make sure that file system is in a
self-consistent state before we return an error up to the caller.

Cheers,

					- Ted
 
