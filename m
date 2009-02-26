From: Theodore Tso <tytso@mit.edu>
Subject: Re: Crash in 2.6.28.7 - ext4 related
Date: Thu, 26 Feb 2009 15:52:45 -0500
Message-ID: <20090226205245.GM7227@mit.edu>
References: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com> <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com> <20090226141946.GE7227@mit.edu> <b637ec0b0902260638u2a07433ayf0ea56fd3e41ec5a@mail.gmail.com> <20090226160829.GH7227@mit.edu> <b637ec0b0902261242o55d67bd9m65a6f26dc8ce1b19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33569 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZBZUwu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 15:52:50 -0500
Content-Disposition: inline
In-Reply-To: <b637ec0b0902261242o55d67bd9m65a6f26dc8ce1b19@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 26, 2009 at 09:42:15PM +0100, Fabio Comolli wrote:
> It's my home directory and so I prefer not to share, sorry. 

No problem, I understand.

> Anyway, it seems that after the removal of that (possibly corrupted)
> directory, I can't reproduce the problem anymore. I tried to create
> / modify / delete some big directories, even two or three at a time
> with no luck.

Did you ever try running e2fsck on the filesystem while you could
reproduce it?  Did it report any errors?  A good thing to do in
general, if you can report these sorts of problems, is to run e2fsck
with the -n option, while the filesystme is unmounted, and see if any
errors are reported.  That would tell us if there were any filesystem
corruption problems (and the -n avoids making any changes to the
filesystem).

Also, even if you don't feel willing to share the e2image file, if you
can reproduce it, please consider making a raw e2image dump.  That way
if the problem goes away again, maybe you'll be able to consistently
report reproduce it on the e2image dump file.  

The other thing that you can do which will sometimes work is to add
the -s option to the e2image command.  The -s option scrambles the
name of the directory entries and zeros out any unused portions of
directory blocks to prevent privacy problems.  The downside is that it
can prevent certain bugs from being repeatable and you have to either
turn off the dir_index feature or run e2fsck to fix up the htree since
the filename hashes will be screwed up after the directory entries are
scrambled.  So it's not ideal, but in cases where there are privacy
issues, that can be helpful.

Regards,

					- Ted
