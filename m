From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] ext4: remove unused d_name argument from
 ext4_search_dir() et al.
Date: Wed, 24 May 2017 18:12:26 -0400
Message-ID: <20170524221226.tmlhu6ye7dy3ilan@thunk.org>
References: <20170523012259.41989-1-ebiggers3@gmail.com>
 <20170523081232.GC1230@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34982 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031756AbdEXWM3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 18:12:29 -0400
Content-Disposition: inline
In-Reply-To: <20170523081232.GC1230@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 23, 2017 at 10:12:32AM +0200, Jan Kara wrote:
> On Mon 22-05-17 18:22:59, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Now that we are passing a struct ext4_filename, we do not need to pass
> > around the original struct qstr too.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
