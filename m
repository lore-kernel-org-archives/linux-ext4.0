From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/11] ext4: remove ext4_end_io()
Date: Fri, 5 Oct 2012 00:28:16 -0400
Message-ID: <20121005042816.GD11723@thunk.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
 <1348847051-6746-6-git-send-email-dmonakhov@openvz.org>
 <CAOMFOmVyqmmepkVOYSjz7kYtqGb0ogpyOzMYAX4KiA9JKBMKaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	jack@suse.cz, lczerner@redhat.com
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53925 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab2JEH3O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 03:29:14 -0400
Content-Disposition: inline
In-Reply-To: <CAOMFOmVyqmmepkVOYSjz7kYtqGb0ogpyOzMYAX4KiA9JKBMKaQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ended up dropping this patch since it doesn't make any difference to
the generated code (gcc will take a static function which is only used
in one place, and inline it) and it makes a bit more understandable to
have ext4_end_io() as a separate function.

> > +               /* Wake up anyone waiting on unwritten extent conversion */
> > +               if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> > +                       wake_up_all(ext4_ioend_wq(io->inode));
> 
> Should we use "inode" instead of "io->inode"?

I agree it would be a bit cleaner/more readable, but again it won't
make a difference to the generated assembly, and while we oculd do
this in the original code in ext4_end_io(), I'm trying to put this
patch series to bed so I can push it to Linus, and since we're now not
touching the code, it's not worth it to clean this up now.  We can
take of this later....

						- Ted
