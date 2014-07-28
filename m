From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH 0/5] e2fsprogs: some small cleanups and fixes for journal
 code
Date: Mon, 28 Jul 2014 17:53:05 +0400
Message-ID: <20140728135305.GD6041@azat>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
 <20140726073329.GB24045@azat>
 <20140726143101.GD6725@thunk.org>
 <20140728080619.GA6041@azat>
 <20140728130022.GN6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64239 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaG1NxK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 09:53:10 -0400
Received: by mail-lb0-f180.google.com with SMTP id v6so5734163lbi.39
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 06:53:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140728130022.GN6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 09:00:22AM -0400, Theodore Ts'o wrote:
> On Mon, Jul 28, 2014 at 12:06:19PM +0400, Azat Khuzhin wrote:
> > 
> > AFAIR it was against master.
> > Yeah massive rename will do a lot of conflicts, I've just rebased them
> > against maint without first patch and sent new patchset (v3).
> 
> Great, thanks!
> 
> For future information, if you are doing development, it's better to
> use either the maint branch (for bug fixes) or the next branch.  The
> next branch is non-rewinding, so it's safe to do development against
> it, and it's generally a few days ahead of the master branch,
> especially after I've added a large number of patches.
> 
> he basic idea is that if there are some end users which are using
> e2fsprogs' master branch, while any patches that get merged into
> "next" should be clean and safe and Bug Free(tm), that we give those
> patches a few days for people to find bugs and really obvious/stupid
> flaws that either (a) I made or that (b) I missed in my review before
> those new commits "graduate" to master.

Yeah, thanks for explanation Ted, I read about this, but I forgot to
change branch before writing patches.

Thanks,
Azat.

