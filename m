From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix off-by-one error when writing back pages
 before dio read
Date: Wed, 24 May 2017 18:08:31 -0400
Message-ID: <20170524220831.45223qit3uzzlntc@thunk.org>
References: <20170523013441.49030-1-ebiggers3@gmail.com>
 <20170523075305.GA1230@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.com>, Eric Biggers <ebiggers@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34952 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164326AbdEXWIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 18:08:35 -0400
Content-Disposition: inline
In-Reply-To: <20170523075305.GA1230@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 23, 2017 at 09:53:05AM +0200, Jan Kara wrote:
> On Mon 22-05-17 18:34:41, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The 'lend' argument of filemap_write_and_wait_range() is inclusive, so
> > we need to subtract 1 from pos + count.
> > 
> > Note that 'count' is guaranteed to be nonzero since
> > ext4_file_read_iter() returns early when given a 0 count.
> > 
> > Fixes: 16c54688592c ("ext4: Allow parallel DIO reads")
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Yeah. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
