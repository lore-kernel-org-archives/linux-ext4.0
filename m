From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: clean up ext4_remove_blocks() return
Date: Fri, 14 Jul 2017 17:01:25 -0400
Message-ID: <20170714210125.GA12793@localhost.localdomain>
References: <20170713151703.GA6383@localhost.localdomain>
 <20170713223351.iqt4owygisqnm6wm@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36665 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdGNU6G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jul 2017 16:58:06 -0400
Received: by mail-qk0-f196.google.com with SMTP id v17so11289562qka.3
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jul 2017 13:58:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170713223351.iqt4owygisqnm6wm@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> On Thu, Jul 13, 2017 at 11:17:03AM -0400, Eric Whitney wrote:
> > ext4_remove_blocks() never returns anything other than 0, signifying
> > success.  Convert the function to void type to make this immediately
> > obvious at the call site.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> 
> Actually, what we should do is to bubble errors up from
> ext4_remove_blocks to the callers of ext4_ext_rm_leaf().  At the
> moment it doesn't return any errors, but eventually we should be
> returning errors all the way up to ext4 truncate.
> 
> The reason why it's a little tricky is it's more than just not
> deleting the call to ext4_std_error() and then returning error up to
> the caller.  We need to make sure that file system is in a
> self-consistent state before we return an error up to the caller.
> 
> Cheers,
> 
> 					- Ted
>

OK, that confirms a suspicion I had.  That looks more like a small project
than a quick cleanup, so I'll withdraw the patch and perhaps revisit this
in the future.

Thanks,
Eric
