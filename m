From: tytso@mit.edu
Subject: Re: ext5
Date: Wed, 10 Feb 2010 23:30:29 -0500
Message-ID: <20100211043029.GE739@thunk.org>
References: <fe37fadb578fb9a3df9c878f8b9e9c3e@remailer.privacy.at>
 <20100210215028.GD739@thunk.org>
 <ea11fea31002101938y7bd5d6f4u5f7cdda972ea72e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Anonymous Remailer (austria)" <mixmaster@remailer.privacy.at>,
	linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60622 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab0BKEah (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Feb 2010 23:30:37 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea31002101938y7bd5d6f4u5f7cdda972ea72e2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2010 at 09:08:36AM +0530, Manish Katiyar wrote:
> 
> Is this design somewhere on net so that we can read/lookup it up ?

Not yet, but the basic idea is to do the compression in userspace,
using libz with regular resync points every 64k or 128k of
uncompressed data.  An array, indexed by each fixed-block of
uncompressed data, is located at the beginning of the file indicating
where each compressed block begins.  The file is stored on-disk
written by the installer in a compressed format, and then the
installer flips an attribute bit which marks the file as containing
compressed data, and which also makes the file immutable.  (Any
attempt to open the file read/write will result in an error.)

The advantage of this scheme is that it minimizes in-kernel
complexity, since the kernel doesn't have to deal with compressing
data, and it means we can use a simpler format which is more efficient
from a compression standpoint since we don't have to deal with random
access writes.

Another advantage of this scheme is that it's relatively easy to do
the bulk of the work in a file system-independent layer.  Some minor
work would be needed to interface the attribute bit and the mmap
reading function into each client filesystem, but it should be
possible to isolate 95% of the work into a filesystem independent
layer, and then make this something which multiple file systems could
take advantage of --- not just ext3 and ext4, but also xfs, btrfs,
etc.

						- Ted


