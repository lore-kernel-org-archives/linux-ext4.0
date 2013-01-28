From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Mon, 28 Jan 2013 19:02:55 +0400
Message-ID: <871ud5fizk.fsf@openvz.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz> <1358510446-19174-5-git-send-email-jack@suse.cz> <87vcamdi6e.fsf@openvz.org> <20130128143647.GD22711@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:55350 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3A1PDA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 10:03:00 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so863472lab.14
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2013 07:02:58 -0800 (PST)
In-Reply-To: <20130128143647.GD22711@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Jan 2013 09:36:47 -0500, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jan 24, 2013 at 01:49:45PM +0400, Dmitry Monakhov wrote:
> > > 1) It may need allocation of extent tree block so ENOSPC is possible.
> > > 2) It complicates end_io handling code
> >
> > As we already discussed your idea is 100% correct, but even with
> > what patch I still able to trigger situation where split it required.
> > I've got following error with this patch applied on top of 7f5118629f7
> > EXT4-fs error (device dm-3): ext4_convert_unwritten_extents_endio:3411:
> > inode #12: comm kworker/u:4: Written extent modified before IO finished:
> > extent logical block 1379787, len 64; IO logical block 1379787, len 21
> 
> So does this patch makes this better enough that it's worth applying
> now?  Or should we hold off until we figure out what's going on with
> the race that you've foind?
Actually this patch consists of two peaces
1) disable merging of uninitialized extents. (1 line change) I'm
absolutely agree with it.
2) Remove explicit extent split inside endio. By assumption explicit
split is workaround against 1'st bug, but even w/ disabled merging
we still have another race which result in situation where split is
required.

At this moment i try to localize this issue. Let's commit first part,
but keep second one until I'll find the race. 
> 
> Thanks,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
