From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] e2fsprogs: some small cleanups and fixes for journal
 code
Date: Mon, 28 Jul 2014 09:00:22 -0400
Message-ID: <20140728130022.GN6725@thunk.org>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
 <20140726073329.GB24045@azat>
 <20140726143101.GD6725@thunk.org>
 <20140728080619.GA6041@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60513 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaG1NAZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 09:00:25 -0400
Content-Disposition: inline
In-Reply-To: <20140728080619.GA6041@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 12:06:19PM +0400, Azat Khuzhin wrote:
> 
> AFAIR it was against master.
> Yeah massive rename will do a lot of conflicts, I've just rebased them
> against maint without first patch and sent new patchset (v3).

Great, thanks!

For future information, if you are doing development, it's better to
use either the maint branch (for bug fixes) or the next branch.  The
next branch is non-rewinding, so it's safe to do development against
it, and it's generally a few days ahead of the master branch,
especially after I've added a large number of patches.

he basic idea is that if there are some end users which are using
e2fsprogs' master branch, while any patches that get merged into
"next" should be clean and safe and Bug Free(tm), that we give those
patches a few days for people to find bugs and really obvious/stupid
flaws that either (a) I made or that (b) I missed in my review before
those new commits "graduate" to master.

Cheers,

							- Ted
