From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Mixup with name_len & file_type in e2fsprogs
Date: Tue, 5 Mar 2013 13:29:46 -0500
Message-ID: <20130305182946.GB26122@thunk.org>
References: <20130305121856.GA11824@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51434 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758236Ab3CESaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Mar 2013 13:30:00 -0500
Content-Disposition: inline
In-Reply-To: <20130305121856.GA11824@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 05, 2013 at 01:18:56PM +0100, Jan Kara wrote:
>   Hello,
> 
>   I was looking into a bug where application using e2fslib was complaining
> about file_type > 7. Now the problem is that this is on big endian system
> and ext2fs_dir_iterate() ends up calling ext2fs_dirent_swab_in() without
> EXT2_DIRBLOCK_V2_STRUCT flag set so name_len is treated as 2 byte and
> swapped.

Well, the application most be passing a pointer to treating a pointer
to a struct ext2_dir_entry as a struct dir_entry_2, right?  So it's
technically doing something wrong it sounds like.

The ext2_dir_entry_2 was probably a mistake, and it's hardly used at
all in e2fsprogs.  I wonder if we would be better off not trying to
support it at all, and perhaps adding better accessor functions for
struct ext2_dir_entry instead.

						- Ted
