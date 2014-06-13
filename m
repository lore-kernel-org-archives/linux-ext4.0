From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Fri, 13 Jun 2014 10:31:57 -0400
Message-ID: <20140613143157.GB23180@thunk.org>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: JP Abgrall <jpa@google.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37537 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaFMOcB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2014 10:32:01 -0400
Content-Disposition: inline
In-Reply-To: <20140613142054.GA23180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 10:20:54AM -0400, Theodore Ts'o wrote:
> 
> If you really want this to work, and be 100% secure, you really need
> to do the secure discard at the file system layer.  The file system
> could make sure that every single block gets a secure discard before
> it gets reused.

BTW, one major downside of doing a secure trim after every time that a
block has been released is that it will massively increase the flash
wear, since if you do a secure trim on a single 4k block in 512k erase
block, assuming that secure trim has been implemented properly from a
security perspective, it will need to copy out all of the used portion
of the 512k erase block, and then erase it.

This is one of the reasons why I asked if you really need to worry
about securely discarding all of the blocks on the file system, or
just blocks containing specific really security-sensitive information
(i.e., for Google Wallet, etc.)

If so, you might be better off either doing per-file encryption, or
per-file secure discard.

Cheers,

					- Ted
