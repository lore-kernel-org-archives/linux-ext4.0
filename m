From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND] libext2fs: Provide functions to safely access name_len
 and file_type
Date: Mon, 10 Jun 2013 08:39:56 -0400
Message-ID: <20130610123956.GA23226@thunk.org>
References: <1369773935-16889-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56569 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3FJMkB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jun 2013 08:40:01 -0400
Content-Disposition: inline
In-Reply-To: <1369773935-16889-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 28, 2013 at 10:45:35AM -0000, Jan Kara wrote:
> Accessing name_len (and file_type) in ext4_dir_entry structure is somewhat
> problematic because on big endian architecture we need to now whether we
> are really dealing with ext4_dir_entry (which has u16 name_len which
> needs byte swapping) or ext4_dir_entry_2 (which has u8 name_len which
> must not be byte swapped).
> 
> Currently the code is somewhat surprising and name_len is always treated
> as u16 and byte swapped (flag EXT2_DIRBLOCK_V2_STRUCT isn't ever used)
> and then masking of name_len is used to access real name_len or
> file_type. Doing things this way in applications using libext2fs is
> unexpected to say the least (more natural is to type struct
> ext4_dir_entry * to struct ext4_dir_entry_2 * but that gives wrong
> results on big endian architectures. So provide helper functions that
> give endian-safe access to these fields. Also convert users in e2fsprogs
> to use these functions.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
