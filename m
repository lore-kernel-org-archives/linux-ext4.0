From: Jan Kara <jack@suse.cz>
Subject: Re: Mixup with name_len & file_type in e2fsprogs
Date: Thu, 7 Mar 2013 19:24:44 +0100
Message-ID: <20130307182444.GA21237@quack.suse.cz>
References: <20130305121856.GA11824@quack.suse.cz>
 <20130305182946.GB26122@thunk.org>
 <20130305184138.GA19601@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab3CGSYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 13:24:48 -0500
Content-Disposition: inline
In-Reply-To: <20130305184138.GA19601@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-03-13 19:41:38, Jan Kara wrote:
> On Tue 05-03-13 13:29:46, Ted Tso wrote:
> > On Tue, Mar 05, 2013 at 01:18:56PM +0100, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   I was looking into a bug where application using e2fslib was complaining
> > > about file_type > 7. Now the problem is that this is on big endian system
> > > and ext2fs_dir_iterate() ends up calling ext2fs_dirent_swab_in() without
> > > EXT2_DIRBLOCK_V2_STRUCT flag set so name_len is treated as 2 byte and
> > > swapped.
> > 
> > Well, the application most be passing a pointer to treating a pointer
> > to a struct ext2_dir_entry as a struct dir_entry_2, right?  So it's
> > technically doing something wrong it sounds like.
>   Yes, that is correct. Although it is easy to think along the lines of
> "I know the dirents are in v2 format but there's no way to iterate over a
> directory and get v2 dirent so I will just cast the v1 argument." And
> although that is wrong as you point out I did that myself a few times
> because I didn't know a better way.
>  
> > The ext2_dir_entry_2 was probably a mistake, and it's hardly used at
> > all in e2fsprogs.  I wonder if we would be better off not trying to
> > support it at all, and perhaps adding better accessor functions for
> > struct ext2_dir_entry instead.
>   Yeah, that sounds like an easier solution. I'll write a patch for that.
> Thanks for the idea.
  I was thinking some more about it. Won't it be cleaner (and not much
harder) if we always used ext2_dir_entry_2 in e2fsprogs and properly did
byte swapping of name_len only if FILETYPE feature isn't enabled? I've
checked and it would mean changing prototypes of like 8 functions in
ext2fs.h (or better provide new functions with struct ext2_dir_entry_2
argument) which doesn't seem too bad... This solution seems to be the least
surprising to the users of libext2fs (esp. if they do some scanning of
directory blocks themselves or so).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
