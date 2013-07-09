From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 Larger Than 16TB
Date: Mon, 8 Jul 2013 22:14:03 -0400
Message-ID: <20130709021403.GC6000@thunk.org>
References: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Michael <mike@draftx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36052 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3GICOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jul 2013 22:14:06 -0400
Content-Disposition: inline
In-Reply-To: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 08, 2013 at 04:32:50PM -0500, Michael wrote:
> I have a currently 15TB FS that I want to expand to 18TB.
> Unfortunately EXT4 e2fsprogs has an issue that stops you from being
> able to do this:
> 
> sudo resize2fs /dev/md0
> resize2fs 1.42.5 (29-Jul-2012)
> resize2fs: New size too large to be expressed in 32 bits
> 
> It seems to me, reading the change logs, that this only supported if
> you created your FS with 64 bit specified. There seems to have been a
> patch last year that added support for changing 32->64bit, but I had a
> hard time finding/tracking that.

Unfortuantely, there is no patch that would enable this.

In theory it could be done; it would require doubling the size of the
block group descriptors, which would require moving other metadata
blocks out of the way.  Resize2fs does do this when growing a file
system off-line when no blocks are available from the resize inode,
but no one has implemented the necessary changes to extend this to
adding the 64-bit feature.

So it's technically possible, but it's not implemented at this time.

Sorry,

							- Ted
