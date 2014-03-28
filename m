From: tytso@mit.edu
Subject: Re: [PATCH] xfstests-bld: Simplify determination of number of CPUs
 in build-all
Date: Fri, 28 Mar 2014 12:18:06 -0400
Message-ID: <20140328161806.GA31772@thunk.org>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46885 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaC1QSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Mar 2014 12:18:11 -0400
Content-Disposition: inline
In-Reply-To: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 28, 2014 at 10:03:19AM +0100, Sedat Dilek wrote:
> Use 'getconf _NPROCESSORS_ONLN' to determine the total number
> of available ("online") CPUs.
> 
> I have seen this 1st in some build-scripts of Grml project and
> had some discussions with Thorsten Glaser on this topic.
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks, applied.

In the future, it would be great at least cc patches to
linux-ext4@vger.kernel.org, since I rely on patchwork to make sure
patches don't end up falling through the cracks.

If we start getting a huge number of patches to xfstests-bld, and
people start getting confused/annoyed about how xfstests-bld issues
get discussed on linux-ext4@vger.kernel.org, while xfstests patches
and discussion happen on xfs@oss.sgi.com, we could consider creating a
new mailing list --- especially given that based on a challenge which
Greg K-H gave us at the kernel pannel at Collab Summit, we'll at least
be looking at cleaning up and then trying to get into the linux kernel
mainline sources some combination of xfstests plus some infrastructure
automation (perhaps strongly based on what I've been working here in
the xfstests-bld tree) to run xfstests.

Cheers,

						- Ted
