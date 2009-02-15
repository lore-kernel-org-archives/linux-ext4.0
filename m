From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RESEND/PATCH] ext[234]: Return -EIO not -ESTALE on directory
	traversal missing inode
Date: Sun, 15 Feb 2009 00:39:12 -0500
Message-ID: <20090215053912.GD10706@mini-me.lan>
References: <1234588099-8445-1-git-send-email-bdonlan@fushizen.net> <1234588688-9497-1-git-send-email-bdonlan@gmail.com> <20090214141411.GD26628@mini-me.lan> <3e8340490902142053x18ae3c20q7018e0d8bc42636d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
To: Bryan Donlan <bdonlan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34994 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZBOFj6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 00:39:58 -0500
Content-Disposition: inline
In-Reply-To: <3e8340490902142053x18ae3c20q7018e0d8bc42636d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 14, 2009 at 11:53:48PM -0500, Bryan Donlan wrote:
> > I'm dubious about unlikely() here; OTOH, penalizing the error case
> > seems reasonable.
> 
> I can leave it without the unlikely(), as it was before, but as far as
> I can tell, this should never happen under a non-corrupted, non-broken
> hardware filesystem, so it seems like a reasonable annotation to me.

You're right.  I was looking at the wrong place in the source, and
thought this could happen if the lookup failed; but yes, you're right,
this case can only happen if the filesystem is corrupted or there is
an I/O error.

						- Ted
