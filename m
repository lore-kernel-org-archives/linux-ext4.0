From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: SECRM, UNRM, COMPR flags
Date: Mon, 26 Sep 2016 11:06:21 -0400
Message-ID: <20160926150621.rp2s5uhkbqzjzixn@thunk.org>
References: <20160926091149.GA7733@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33332 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031988AbcIZPHm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Sep 2016 11:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20160926091149.GA7733@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 26, 2016 at 11:11:49AM +0200, Jan Kara wrote:
> 
> in ext4 we have these SECRM, UNRM, COMPR flags which users can set, they
> can read them, but which actually don't do anything. This is actually
> somewhat confusing - e.g. I've just got report about one tool which
> apparently sets SECRM flag on a file in a hope that it is somehow safer.
> Also this is a waste of flags.

I agree it doesn't seem very likely we'll be using UNRM any time soon.
I can imagine using SECRM and COMPR, but in particular for COMPR it
will probably be in a different way (the package manager would install
a file that would be compressed in userspace, and then using a
*different* ioctl from IOC_SETFLAGS, the COMPR flag would be set and
that would make the file immutable and the decompression would be done
in userspace).

> I've checked other filesystems (xfs, btrfs) and they report EOPNOTSUPP if
> these flags are not really supported. Should not we do the same in ext4? I
> know there is a concern about breaking userspace but since other major
> filesystems already behave this way I think there is a good chance tools
> handle this reasonably... What do people thing?

What we've been doing for other flags that we don't set is that we
simply mask them off (see EXT4_FL_USER_MODIFIABLE) so attempt so set
them will be a no-op.

What I think would make sense is to simply remove UNRM, SECRM, and
UNRM from the USER_MODIFIABLE bitmask.  I also suspect it might be
useful to define a new ioctl which returns the USER_VISIBLE and
USER_MODIFIABLE bitmasks, so that tools can know how to expect (and
give warning or error messages as desired).

What do folks think?

						- Ted
