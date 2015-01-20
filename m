From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Fix of coding style
Date: Tue, 20 Jan 2015 12:27:09 -0500
Message-ID: <20150120172709.GB24217@thunk.org>
References: <BLU436-SMTP13588542A2A18325E005EF8D94B0@phx.gbl>
 <54BE4C0B.3030703@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Mrazek <email@honzamrazek.cz>, linux-ext4@vger.kernel.org,
	trivial@kernel.org, Jiri Slaby <gep@mail.muni.cz>
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51402 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbbATR1V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jan 2015 12:27:21 -0500
Content-Disposition: inline
In-Reply-To: <54BE4C0B.3030703@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 20, 2015 at 01:37:31PM +0100, Jiri Slaby wrote:
> On 01/20/2015, 12:59 PM, Jan Mrazek wrote:
> > - init_timer changed to setup_timer
> > - multiline strings changed to single line (so it can be greped)
> > - other small conding style changes
> > 
> > Signed-off-by: Jan Mrazek <email@honzamrazek.cz>
> 
> Note that one hunk does not apply cleanly here:
>  Hunk #35 succeeded at 3581 with fuzz 1 (offset 16 lines).
> 
> What tree did you use as a base? Care to rebase?
> 
> Reviewed-by: Jiri Slaby <jslaby@suse.cz>
> 
> (There is a nit: leaving up to the maintainers if they insist on
> separating the setup_timer change or not :).)

Yes, please separate it out; in general I'm not terribly excited about
these sorts of massive cleanup patches, because it breaks patches that
other people send me.  (I'll also note that many of the multi-line
separations happened people running checkpatch sent me cleanup
patches; so the fact that I'm now getting a cleanup patch to reverse
this also predisposes me to not be very receptive to these sorts of
cleanups.  I will generally ask developers to send me checkpatch clean
patches, but I'm less enthusiastic about cleanup patches for their own
sake.)

That being said, the setup_timer change is small, and less disruptive,
so separating that out is good because I will likely accept the
setup_timer change, but probably not the multi-line string change,
since regardless of what you base it against, there is a very good
chance it won't apply against the ext4 development tree --- and if it
does, it will likely break other patches that people send me.

Cheers,

						- Ted
