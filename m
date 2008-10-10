From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] logsave : Avoid unnecessary backgrounding of logsave
	in case of failures
Date: Fri, 10 Oct 2008 14:31:57 -0400
Message-ID: <20081010183157.GD8645@mit.edu>
References: <ea11fea30810071044l6d8887e0udb52342f82412e4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56473 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759469AbYJJSb6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 14:31:58 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30810071044l6d8887e0udb52342f82412e4a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2008 at 11:14:11PM +0530, Manish Katiyar wrote:
> Hi Ted,
> 
> I am not sure why we wan't to background the logsave and keep retrying
> opening the fd in case of failures. 

That's one of the main reason why logsave exists; the filesystem
containing /var/log might not be mounted, or the root filesystem may
be mounted read-only, and so the log file can't be written until the
filesystem is remounted r/w or /var is mounted.

> But there may be situations when we will never be able to succeed
> and thus create unnecessary process. For example invoking it
> 
> /home/mkatiyar/sbin> ./logsave /testfile ls

The main use of logsave was in init.d scripts.  So I didn't really
worry about the permissoin denied case.  Perhaps logsave should just
fail hard and not even run the command if there is a permission denied
error.  That would certainly be simpler...

> +static void should_background(int err, int *nobackground) {
> +	switch (err) {
> +		case EPERM:
> +		case EACCES:
> +			*nobackground = err;
> +			break;
> +		default :
> +			*nobackground = 0;
> +	}
> +	return ;
> +}

Why is this its own function?

						- Ted
