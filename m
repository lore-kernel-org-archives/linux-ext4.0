From: Jan Kara <jack@suse.cz>
Subject: Mixup with name_len & file_type in e2fsprogs
Date: Tue, 5 Mar 2013 13:18:56 +0100
Message-ID: <20130305121856.GA11824@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3CEMS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Mar 2013 07:18:58 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  I was looking into a bug where application using e2fslib was complaining
about file_type > 7. Now the problem is that this is on big endian system
and ext2fs_dir_iterate() ends up calling ext2fs_dirent_swab_in() without
EXT2_DIRBLOCK_V2_STRUCT flag set so name_len is treated as 2 byte and
swapped. There's actually no way to pass that flag from directory iteration
functions to ext2fs_dirent_swab_in() and even worse looking into various
directory handling code in libext2fs if that flag was *ever* used, they
will get seriously confused because they expect (dirent->name_len & 0xff)
to be the real name length but on big endian systems with
EXT2_DIRBLOCK_V2_STRUCT set that isn't true anymore (real name length ends
up in the high byte of the word).

The application could obviously just do what libext2fs does all the time
and use old struct ext2_dir_entry, extract file_type as (name_len >> 8), and
name length as (name_len & 0xff) but that just seems wrong... Rather
directory functions in libext2fs should use EXT2_FEATURE_INCOMPAT_FILETYPE
to recognize what directory structure to use and act accordingly. But that
would be a non-trivial change and we'll have to update also some user
interfaces. So would people find such cleanup useful?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
