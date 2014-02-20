From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused ac_ex_scanned
Date: Thu, 20 Feb 2014 13:33:55 -0500
Message-ID: <20140220183355.GA24360@thunk.org>
References: <51F6F73B.3050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60555 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaBTTjI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 14:39:08 -0500
Content-Disposition: inline
In-Reply-To: <51F6F73B.3050809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 06:14:03PM -0500, Eric Sandeen wrote:
> When looking at a bug report with:
> 
> > kernel: EXT4-fs: 0 scanned, 0 found
> 
> I thought wow, 0 scanned, that's odd?  But it's not odd; it's printing
> a variable that is initialized to 0 and never touched again.
> 
> It's never been used since the original merge, so I don't really even
> know what the original intent was, either.
> 
> If anyone knows how to hook it up, speak now via patch, otherwise just
> yank it so it's not making a confusing situation more confusing in
> kernel logs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Sorry for losing track of this patch.  Since Andreas was sitting next
to me at FAST, when I was going through the patchwork backlog, I
conferred with him, and he agreed that we should just nuke
ac_ex_scanned as you proposed.

Thanks, applied.

						- Ted
