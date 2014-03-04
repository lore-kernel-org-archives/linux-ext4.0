From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Speedup WB_SYNC_ALL pass
Date: Tue, 4 Mar 2014 10:54:43 -0500
Message-ID: <20140304155443.GD23106@thunk.org>
References: <1393887208-19462-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36879 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbaCDPyr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2014 10:54:47 -0500
Content-Disposition: inline
In-Reply-To: <1393887208-19462-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 11:53:28PM +0100, Jan Kara wrote:
> When doing filesystem wide sync, there's no need to force transaction
> commit (or synchronously write inode buffer) separately for each inode
> because ext4_sync_fs() takes care of forcing commit at the end (VFS
> takes care of flushing buffer cache, respectively). Most of the time
> this slowness doesn't manifest because previous WB_SYNC_NONE writeback
> doesn't leave much to write but when there are processes aggressively
> creating new files and several filesystems to sync, the sync slowness
> can be noticeable. In the following test script sync(1) takes around 6
> minutes when there are two ext4 filesystems mounted on a standard SATA
> drive. After this patch sync takes a couple of seconds so we have about
> two orders of magnitude improvement.
> 
>       function run_writers
>       {
>         for (( i = 0; i < 10; i++ )); do
>           mkdir $1/dir$i
>           for (( j = 0; j < 40000; j++ )); do
>             dd if=/dev/zero of=$1/dir$i/$j bs=4k count=4 &>/dev/null
>           done &
>         done
>       }
> 
>       for dir in "$@"; do
>         run_writers $dir
>       done
> 
>       sleep 40
>       time sync
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, thanks for the patch!

						- Ted
