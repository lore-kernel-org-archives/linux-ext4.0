From: tytso@mit.edu
Subject: Re: Q wrt LVM snapshot of ext4 w/ external journal
Date: Tue, 13 Apr 2010 15:22:57 -0400
Message-ID: <20100413192257.GP1849@thunk.org>
References: <4BC4B66B.9000205@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49773 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab0DND51 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Apr 2010 23:57:27 -0400
Content-Disposition: inline
In-Reply-To: <4BC4B66B.9000205@nuclearwinter.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 13, 2010 at 01:22:35PM -0500, Larkin Lowrey wrote:
> Is it safe to mount an LVM2 snapshot of an ext4 fs that has an external
> journal?
> 
> My googling has revealed only that the snapshot procedure will cause the
> fs to checkpoint the journal (if that's the right term) but also that
> the fs will want to replay the journal when mounted, even if -o ro. If
> my journal is on an external device (NVRAM device in my case) I don't
> want the snapshot instance to interfere with the main on-line fs's use
> of the journal.

It's safe to mount the LVM2 snapshot only if you use the mount option
noload.  This will prevent it from using the journal, which is good,
since the journal is in use by the original file system.  :-)

> Is there any documentation, other than code, that describes this scenario?

No, it's not documented.  It probably should be.

Hopefully, mounting the snapshot without using noload _should_ fail,
since the journal is already in use, but I'm not sure we have that
check in place, so I don't recommend trying it on a production file
system.

						- Ted
