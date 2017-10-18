From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Convert timers to use timer_setup()
Date: Wed, 18 Oct 2017 12:44:05 -0400
Message-ID: <20171018164405.4gaigxecovw7jkny@thunk.org>
References: <20171005004846.GA23025@beast>
 <20171010112050.GB3667@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010112050.GB3667@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 10, 2017 at 01:20:50PM +0200, Jan Kara wrote:
> On Wed 04-10-17 17:48:46, Kees Cook wrote:
> > In preparation for unconditionally passing the struct timer_list pointer to
> > all timer callbacks, switch to using the new timer_setup() and from_timer()
> > to pass the timer pointer explicitly.
> > 
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Jan Kara <jack@suse.com>
> > Cc: linux-ext4@vger.kernel.org
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
