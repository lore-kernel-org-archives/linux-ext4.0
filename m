From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: remove checker infrastructure
Date: Fri, 4 Jul 2014 08:48:24 -0400
Message-ID: <20140704124824.GE10514@thunk.org>
References: <53505032.5060303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaGDMs0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 08:48:26 -0400
Content-Disposition: inline
In-Reply-To: <53505032.5060303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 05:05:38PM -0500, Eric Sandeen wrote:
> Per http://www.gnu.org/software/checker/ the gcc "-checker" option
> is long deprecated.  Nuke it from e2fsprogs.
> 
> Most people would never hit this, but people who love to turn
> knobs, such as the reporter of kernel.org bz#74171, might
> run into it and be sad.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied, with the necessary fixups so that e2fsprogs would
actually compile afterwards.  :-)

(You didn't remove the @MAKEFILE_CHECKER@ from the Makefiles, and left
a dependency on lib/Makefile.checker in MCONFIG.)

Cheers,

					- Ted
