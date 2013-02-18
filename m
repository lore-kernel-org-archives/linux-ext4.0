From: Theodore Ts'o <tytso@mit.edu>
Subject: Re:
Date: Sun, 17 Feb 2013 22:59:50 -0500
Message-ID: <20130218035950.GA10361@thunk.org>
References: <CAFJqGkO3djXZHRxX0SUZ23EFvagYOEk=KUSkiHg2SgMu-QOLoQ@mail.gmail.com>
 <229CCD67-675F-4FB0-93B2-491DDA6BB7C3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Somchai Smythe <buraphalinuxserver@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48693 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab3BRD74 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Feb 2013 22:59:56 -0500
Content-Disposition: inline
In-Reply-To: <229CCD67-675F-4FB0-93B2-491DDA6BB7C3@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 17, 2013 at 05:42:03PM -0500, Eric Sandeen wrote:
> 
> I haven't looked closely at this, but you could unmount and do
> "e2image -r" of the fs to copy a metadata image.  If e2fsck fails
> the same way on the image, you've saved a reproducer, and you could
> re-make /tmp if you like.

This is good advice; in general this error occurs when there is a
hardware problem, where after we finishing running the journal, the
"needs recovery flag" is cleared, and then we close the file system
(to flush our internal caches, since the on-disk blocks might have
gotten updated from running the journal), and then re-open it.  If the
"needs recovery" flag is still set, then we issue this message.  It
indicates either a severe programming bug in e2fsck and its libraries
(in which case having a reproducible test case is really interesting),
or much more commonly, it means that the disk write to the superblock
to clear the "needs recovery" flag didn't "take", and the disk
returned a data block different from the one which we just wrote, thus
indicating some kind of hardware problem.

>From the e2fsck sources

			if (ctx->flags & E2F_FLAG_RESTARTED) {
				/*
				 * Whoops, we attempted to run the
				 * journal twice.  This should never
				 * happen, unless the hardware or
				 * device driver is being bogus.
				 */
				com_err(ctx->program_name, 0,
					_("unable to set superblock flags on %s\n"), ctx->device_name);
				fatal_error(ctx, 0);
			}

Regards,

						- Ted
