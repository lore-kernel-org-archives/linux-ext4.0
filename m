From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Mon, 28 Jan 2013 09:36:47 -0500
Message-ID: <20130128143647.GD22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <87vcamdi6e.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45859 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab3A1Ohb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:37:31 -0500
Content-Disposition: inline
In-Reply-To: <87vcamdi6e.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 01:49:45PM +0400, Dmitry Monakhov wrote:
> > 1) It may need allocation of extent tree block so ENOSPC is possible.
> > 2) It complicates end_io handling code
>
> As we already discussed your idea is 100% correct, but even with
> what patch I still able to trigger situation where split it required.
> I've got following error with this patch applied on top of 7f5118629f7
> EXT4-fs error (device dm-3): ext4_convert_unwritten_extents_endio:3411:
> inode #12: comm kworker/u:4: Written extent modified before IO finished:
> extent logical block 1379787, len 64; IO logical block 1379787, len 21

So does this patch makes this better enough that it's worth applying
now?  Or should we hold off until we figure out what's going on with
the race that you've foind?

Thanks,

					- Ted
