From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Misbehaving SSDs - FTL corruption
Date: Tue, 4 Jun 2013 15:19:36 -0400
Message-ID: <20130604191936.GT3030@thunk.org>
References: <CADzUK1JDVJfs_iCe6hk1VFsFmTBCdLtbWCr0aRRa-dGVpxCtLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54851 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab3FDTTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 15:19:40 -0400
Content-Disposition: inline
In-Reply-To: <CADzUK1JDVJfs_iCe6hk1VFsFmTBCdLtbWCr0aRRa-dGVpxCtLQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 03, 2013 at 02:02:10PM -0400, Autif Khan wrote:
> We found that a relatively expensive Intel Enterprise SSD works perfectly.
> 
> Some relatively inexpensive Crucial, OCZ and Sandisk SSDs do not.

Who knows?  You need to ask the SSD vendors; as a file system
developer, all I know is that after the disk lets us know that a
CACHE_FLUSH command has completed, everything is supposed to be on
stable store, including any FTL data.  

We have no other way of influencing what the storage device might
decide to do.

> Is there a separate command/syscall to tell the SSD to flush its FTL?

There is no separate SATA command.  Just the CACHE_FLUSH SATA command,
and this is what ext4 issues in response to a fsync(2) system call.

It may be that if you wait 30 seconds after the last disk write,
hopefully the crappy SSD has gotten around to writing out all of its
necessary data and metadata.  You shouldn't have to do that, but if
you have a crappy drive, you have a crappy drive.

Is there some reason you can use a controlled shutdown most of the
time?

						- Ted
