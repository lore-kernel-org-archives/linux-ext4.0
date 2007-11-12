From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize
Date: Mon, 12 Nov 2007 09:58:23 -0500
Message-ID: <20071112145823.GB17462@thunk.org>
References: <20071106113142.GA23689@duck.suse.cz> <20071107160939.GF22214@duck.suse.cz> <20071111003703.GA14815@thunk.org> <20071112095245.GA1465@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35940 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXKLO6a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2007 09:58:30 -0500
Content-Disposition: inline
In-Reply-To: <20071112095245.GA1465@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 12, 2007 at 10:52:45AM +0100, Jan Kara wrote:
> > Did you test this patch before submitting it?
>
>   Argh, stupid me. I've just tested that I didn't break anything for normal
> block size and thought that I cannot make mistake in such a simple thing
> ;).

Could I ask you to perhaps include some 64k blocksize test cases that
would exercise the new codepaths?

> > The only way to do this is to find all of the places that reference
> > rec_len, and do the check there.
>   Yes.. Thanks for having look.

One suggestion is that instead of just creating an conversion
function, and then doing a global search and replace, in some places
it might be better to declare an integer variable, and then assign
"rec_len = ext2fs_rec_len_from_disk(dirent->rec_len)".  For example,
that would make ext2fs_process_dir_block() more readable, where
dirent->rec_len is used no less than eight times.

Thanks, and my apologies for not having time to review the patch until
now.  At the moment things are a bit crazy since I am effectively
doing two jobs, since I am in transition between two assignments, and
me doing most of both of them at the moment.  I should have
substantially more time after the new year begins.

						- Ted
