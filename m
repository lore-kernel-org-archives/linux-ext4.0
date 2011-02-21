From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] mke2fs: Inform user of ongoing discard
Date: Sun, 20 Feb 2011 21:58:13 -0500
Message-ID: <20110221025813.GA23822@thunk.org>
References: <1295898720-2221-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53400 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab1BUDeY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 22:34:24 -0500
Content-Disposition: inline
In-Reply-To: <1295898720-2221-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, merged into the next branch of e2fsprogs

						- Ted

On Mon, Jan 24, 2011 at 08:52:00PM +0100, Lukas Czerner wrote:
> (V2: remove MB macro)
> 
> For some time now we are doing initial discard of the device prior to
> filesystem creation. However, there is no feedback for the user and
> hence on some devices with slow TRIM implementation it may appear that
> mke2fs is stuck.
> 
> This commit introduce new function mke2fs_discard_device(), which is a
> wrapper for io_channel_discard(). The discard is done per-partes and
> discard progress is being reported back to the user. The discard step
> has been set to 2GB size, which works reasonably well on both slow and
> fast devices.
> 
> I gave up on doing fancy things like align discard according to
> discard_alignment, checking for discard granularity and computing
> estimate time. First of all, because it would require either new ioctl
> to retrieve those information or use of libudev library, none of it
> seems to be worth it. Regarding discard_granularity, I doubt there is
> any sane device with discard granularity that big it would affect this.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
