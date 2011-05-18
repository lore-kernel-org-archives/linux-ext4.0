From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4 v3] tests: New i_e2image test to validate image
 creation/conversion
Date: Wed, 18 May 2011 12:19:30 -0400
Message-ID: <20110518161930.GE29368@thunk.org>
References: <1305718615-5991-1-git-send-email-lczerner@redhat.com>
 <1305718615-5991-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60005 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462Ab1ERQTc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 12:19:32 -0400
Content-Disposition: inline
In-Reply-To: <1305718615-5991-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 01:36:55PM +0200, Lukas Czerner wrote:
> This commit adds new regression test called i_e2image which should
> validate expected behaviour of e2image raw and qcow2 image creation
> and qcow2 -> raw image conversion. You can run it with "make check" as
> the rest of regression tests.
> 
> Testing is performed on three filesystem images with different block
> sizes (1024, 2048, 4096). It creates raw and qcow2 images from the
> original and then convert qcow2 image back to raw image. The results are
> checksummed and compared with pre-prepared results. All md5sums should
> stay the same and raw image created from original and qcow2 image should
> be the same as well (just for the record).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied into the e2fsprogs next branch.

I had to fix up this commit so that it works when you are using a
$VPATH build directory.  Note that, temp files for tests should go in
the current directory, and that files in the source file have to be
referenced via $SRCDIR.

					- Ted
