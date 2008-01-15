From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Do not try lock_acquire after handle made invalid
Date: Tue, 15 Jan 2008 15:59:14 -0800
Message-ID: <20080115155914.c72aaea9.akpm@linux-foundation.org>
References: <12004403661489-git-send-email-jonas.bonn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, linux-ext4@vger.kernel.org, jonas.bonn@gmail.com
To: Jonas Bonn <jonas.bonn@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbYAPAA3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2008 19:00:29 -0500
In-Reply-To: <12004403661489-git-send-email-jonas.bonn@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jan 2008 00:39:26 +0100
Jonas Bonn <jonas.bonn@gmail.com> wrote:

> This likely fixes the oops in __lock_acquire reported as:
> 
> http://www.kerneloops.org/raw.php?rawid=2753&msgid=
> http://www.kerneloops.org/raw.php?rawid=2749&msgid=
> 
> In these reported oopses, start_this_handle is returning -EROFS.
> 
> Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
> ---
>  fs/jbd/transaction.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 08ff6c7..038ed74 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -288,10 +288,12 @@ handle_t *journal_start(journal_t *journal, int nblocks)
>  		jbd_free_handle(handle);
>  		current->journal_info = NULL;
>  		handle = ERR_PTR(err);
> +		goto out;
>  	}
>  
>  	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
>  
> +out:
>  	return handle;
>  }

Yeah, thanks.

It looks like we forgot to port this lockdep support into ext4.  This is
bad.  What else got lost?
