From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs (device loop0): panic forced after error -- bug or not?
Date: Tue, 1 Dec 2015 10:32:02 -0500
Message-ID: <20151201153202.GA3179@thunk.org>
References: <565DAD0A.6030305@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60162 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbbLAPcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2015 10:32:04 -0500
Content-Disposition: inline
In-Reply-To: <565DAD0A.6030305@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2015 at 03:22:02PM +0100, Vegard Nossum wrote:
> 
> I'm a bit unsure about whether this is really a bug or not; it looks
> like the filesystem is set to panic on error but I still find it weird
> that this behaviour is allowed by default (would it still panic if
> somebody inserted this filesystem on a USB stick and it got automounted?).

If the distribution cares about this, it should automount with mount
option "errors=remount-ro".

> I call mount() with mountflags=0 and data=NULL followed by opendir() and
> readdir(), but if I just a manual mount + ls from the shell I don't see
> the panic at all, just some of the errors, so I thought maybe there's
> some sort of race somewhere?

I'm not able to reproduce this; I'm getting EACCES to the opendir().

But looking at your kernel messages, it's not a bug.

Cheers,

						- Ted
