From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix checks for data=ordered and
 journal_async_commit options
Date: Sat, 3 Dec 2016 16:22:44 -0500
Message-ID: <20161203212244.dnhtzueim6pq6zj7@thunk.org>
References: <1480344222-1234-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Wolfgang Walter <linux@stwm.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33856 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbcLCVWw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 3 Dec 2016 16:22:52 -0500
Content-Disposition: inline
In-Reply-To: <1480344222-1234-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2016 at 03:43:42PM +0100, Jan Kara wrote:
> Combination of data=ordered mode and journal_async_commit mount option
> is invalid. However the check in parse_options() fails to detect the
> case where we simply end up defaulting to data=ordered mode and we
> detect the problem only on remount which triggers hard to understand
> failure to remount the filesystem.
> 
> Fix the checking of mount options to take into account also the default
> mode by moving the check somewhat later in the mount sequence.
> 
> Reported-by: Wolfgang Walter <linux@stwm.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

				- Ted
