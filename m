From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/4 v2] e2fsck: make a prompt message simpler and thus
 translatable
Date: Tue, 3 Jun 2014 22:07:19 -0400
Message-ID: <20140604020719.GC27426@thunk.org>
References: <20140602234001.GJ30598@thunk.org>
 <1401827722-13286-1-git-send-email-bensberg@justemail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49137 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaFDCHW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2014 22:07:22 -0400
Content-Disposition: inline
In-Reply-To: <1401827722-13286-1-git-send-email-bensberg@justemail.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2014 at 10:35:22PM +0200, Benno Schulenberg wrote:
> It can be made simpler because there is no need to differentiate between
> having an internal journal inode and having an external journal device.
> 
> Signed-off-by: Benno Schulenberg <bensberg@justemail.net>

You forgot to fix up the regression test suite f_extra_journal so
"make check" doesn't fail.

I've taken care of it, but in general before sending patches, I'd
appreicate a quick run of "make -j8 check" (or -j16 if you have a more
powerful machine).

Cheers,

					- Ted
