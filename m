From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: do not change root dir ownership
Date: Mon, 13 May 2013 17:06:13 -0400
Message-ID: <20130513210613.GB20102@thunk.org>
References: <1367875316-3089-1-git-send-email-vapier@gentoo.org>
 <20130513133731.GC4845@thunk.org>
 <201305131212.28657.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48139 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab3EMVGT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 17:06:19 -0400
Content-Disposition: inline
In-Reply-To: <201305131212.28657.vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 13, 2013 at 12:12:27PM -0400, Mike Frysinger wrote:
> nifty.  we already have to mount the fs to populate it, so putting a chown in 
> there isn't a big deal in the current setup.
> 
> now if only e2fsprogs would integrate the `genext2fs` project :).

Darren Hart created a shell script which uses debugfs to do all of the
dirty work, called populate-extfs.sh which I believe Linaro and the
Yocto project is using instead of genext2fs.

I'm not entirely sure this the latest version, but so you can get a
flavor of the script, see:

http://patches.openembedded.org/patch/45415/

Darren, if you think the script is pretty stable, I'd be happy to drop
the latest version of it into the contrib directory of e2fsprogs.

Cheers,

					- Ted
