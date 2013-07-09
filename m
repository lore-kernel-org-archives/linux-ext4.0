From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] ext4: Fix warning in ext4_evict_inode()
Date: Tue, 9 Jul 2013 13:38:08 -0700
Message-ID: <20130709203808.GA6382@roeck-us.net>
References: <1373399484-10406-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45156 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3GIUiJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 16:38:09 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so5606029pdj.3
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jul 2013 13:38:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1373399484-10406-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 09, 2013 at 09:51:24PM +0200, Jan Kara wrote:
> The following race can lead to ext4_evict_inode() seeing i_ioend_count
> > 0 and thus triggering a sanity check warning:
> 
>         CPU1                                    CPU2
> ext4_end_bio()                          ext4_evict_inode()
>   ext4_finish_bio()
>     end_page_writeback();
>                                           truncate_inode_pages()
>                                             evict page
>                                         WARN_ON(i_ioend_count > 0);
>   ext4_put_io_end_defer()
>     ext4_release_io_end()
>       dec i_ioend_count
> 
> This is possible use-after-free bug since we decrement i_ioend_count in
> possibly released inode.
> 
> Since i_ioend_count is used only for sanity checks one possible solution
> would be to just remove it but for now I'd like to keep those sanity
> checks to help debugging the new ext4 writeback code.
> 
> This patch changes ext4_end_bio() to call ext4_put_io_end_defer() before
> ext4_finish_bio() in the shortcut case when unwritten extent conversion
> isn't needed. In that case we don't need the io_end so we are safe to
> drop it early.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

I just saw the problem again, oddly enough while building an image
with this patch.

I'll run the kernel with the patch and let you know how it goes.

Guenter
