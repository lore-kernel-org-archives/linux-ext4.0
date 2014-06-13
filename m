From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Fri, 13 Jun 2014 10:20:54 -0400
Message-ID: <20140613142054.GA23180@thunk.org>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: JP Abgrall <jpa@google.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37510 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbaFMOVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2014 10:21:00 -0400
Content-Disposition: inline
In-Reply-To: <20140613050703.GT4453@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 03:07:03PM +1000, Dave Chinner wrote:
> > 
> > Arg. So, if understand this correctly, if the eMMC chip won't get a
> > secure discard/trim of a block that gets reassigned to the FS, then
> 						      ^^ within
> 
> > data duplicates within the eMMC related to that block are not cleared,
> > and the next SFITRIM won't even reach that block or the duplicates as
> > the FS says they are in use.
> 
> Pretty much.

If you really want this to work, and be 100% secure, you really need
to do the secure discard at the file system layer.  The file system
could make sure that every single block gets a secure discard before
it gets reused.  Now as long as you can be sure the flash controller
won't discard certain trims because the range is too small or the
flash controller is too busy (DISCARD is "advisory" which means the
flash controller is free to drop any discard request on the floor; you
should check and see if secure discard is a similarly advisory
request.  Yes, that would be broken, but the flash controller
developers leaned on the standards bodies to make discard_zeros_data
to be similarly useless.)

One question --- do you really need to use secure discard on all
blocks, or just on certain critical bits of data?  If so, there may be
other ways of meeting your security requirements.  One of the things
which Michael Halcrow has been implementing for filesystem level
encryption for ChromeOS, so that selecting ext4 files can be encrypted
using per-user keys.  He recently has gotten his proof of concept
working with a global fixed key, so he's pretty far along.  (Although
I'm sure we'll need to do quite a bit of cleanup before it will be
ready for upstream submission.)  Depending on what your security
requirements are, perhaps this might help meet your security
requirements.

Feel free to contact Michael and I at our google.com e-mails and
perhaps schedule a meeting if that would be helpful.

Cheers,

						- Ted
