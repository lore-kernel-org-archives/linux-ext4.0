From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Tue, 17 Jun 2014 07:27:35 -0400
Message-ID: <20140617112735.GA6537@thunk.org>
References: <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org>
 <20140617024953.GG9508@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: JP Abgrall <jpa@google.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140617024953.GG9508@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 17, 2014 at 12:49:53PM +1000, Dave Chinner wrote:
> >     The blkdicard ioctl previously only worked on block devices.  Allow
> >     this ioctl to work on ext4 files.
> >     
> >     This commit is intended to be sent upstream.
> 
> Not in that form - it's an ugly API hack.

The whole *point* was that it's an API hack.  We had a userspace
program that wanted to use the same code regardless of whether it was
accessing a block device or a file, and we didn't want to spin up a
KVM just to simulate a block device (think the whole countainers
vs. virtualization argument).

> This is really just an extension of hole punching (if the blocks in
> the file are being removed) or zeroing (if the blocks are being
> retained by the file). Either way, fallocate() is the interface
> used for per-file block level manipulations, and either of these
> operations could issue a discard (secure or not) during the
> punch/zero operation....

Except that discard is not an exact equivalent of zeroing, since even
in the case of discard zeros data, the flash device is free to
disregard the discard request if it feels like it.  But if you have a
userspace application which is trying to manage the flash to optimize
write endurance, that's different from either hole punching or
zeroing.

Secure discard maps a bit more like a zero'ing or hole punching, since
hopefully the standard for secure discard was as incompetently
authored as the discard/trim specification.  So that might be a
different approach if this is an approach that we want to get adoption
across multiple file systems.

						- Ted
