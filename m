From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Convert timers to use timer_setup()
Date: Wed, 18 Oct 2017 12:46:21 -0400
Message-ID: <20171018164621.iu2hqtqvjomvu25w@thunk.org>
References: <20171017000019.GA102779@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34322 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbdJRQqY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Oct 2017 12:46:24 -0400
Content-Disposition: inline
In-Reply-To: <20171017000019.GA102779@beast>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 16, 2017 at 05:00:19PM -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
