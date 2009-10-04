From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V3] mke2fs: get device topology values from blkid
Date: Sun, 4 Oct 2009 15:16:54 -0400
Message-ID: <20091004191654.GA13512@mit.edu>
References: <4AB2B6B9.7010506@redhat.com> <4AB7B27B.40008@redhat.com> <4AC62B2A.4020007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39971 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743AbZJDTRh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Oct 2009 15:17:37 -0400
Content-Disposition: inline
In-Reply-To: <4AC62B2A.4020007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 02, 2009 at 11:32:42AM -0500, Eric Sandeen wrote:
> Handle automatic selection of stride/stripe:
>
> # misc/mke2fs /dev/md0 mke2fs 1.41.9 (22-Aug-2009)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=16 blocks, Stripe width=32 blocks
> ...
>
> And warn on block device misalignment:
>
> # misc/mke2fs /dev/sdc1 mke2fs 1.41.9 (22-Aug-2009)
> /dev/sdc1 alignment is offset by 32256 bytes.
> This may result in very poor performance, (re)-partitioning suggested.
> Proceed anyway? (y,n)
>
> V2:
> Add blkid_free_probe() per kzak
> Add alignment check and warning message for misalignment
>
> V3: use new blkid_new_probe_from_filename to drop some LOC
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied to the maint branch.  I added (in the previous commit)
a fairly simple fix to the build system to make sure that we use the
system-provided header files for blkid or uuid if we are using the
system-provided blkid or uuid libraries.  I've tested most of the
combinations except for with the latest bleeding edge blkidv2
libraries --- can you double check to make it works in that case.
>From what I can tell, it should.

						- Ted
