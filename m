From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [Bug 25352] New: resizing ext4 will corrupt filesystem
Date: Tue, 21 Dec 2010 13:28:34 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012211327180.6010@dhcp-lab-213.englab.brq.redhat.com>
References: <20101221033209.GA6924@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab0LUM3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 07:29:02 -0500
In-Reply-To: <20101221033209.GA6924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Dec 2010, Ted Ts'o wrote:

> On Mon, Dec 20, 2010 at 08:56:46PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > 
> > Using resize2fs on an ext4 will result in a corrupted filesystem. This is a
> > regression (obviously).
> 
> Yes, this is a regression new to 2.6.37-rc1, which was introduced by
> commit a31437b85: ext4: use sb_issue_zeroout in setup_new_group_blocks.
> 
> When we replaced the loop zero'ing the inode table blocks with
> sb_issue_zeroout, we accidentally also removed this little tidbit:
> 
> -               ext4_set_bit(bit, bh->b_data);
> 
> ... which was responsible for setting the block allocation bitmap to
> reserve the block descriptor blocks and inode table blocks.  Oops...
> 
> I believe this patch should fix things.
> 
> 						- Ted
> 
> 
> 

Oops indeed. Ted, thanks for the patch, it seems to fix the problem
completely.

-Lukas
