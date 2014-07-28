From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4 v3] e2fsprogs journal fixes (UUID and 1k block size
 issue)
Date: Mon, 28 Jul 2014 17:05:19 -0400
Message-ID: <20140728210519.GE17378@thunk.org>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
 <44E07A0C-5817-4F0A-A58E-87FC2627846D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org,
	darrick.wong@oracle.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33179 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaG1VFX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 17:05:23 -0400
Content-Disposition: inline
In-Reply-To: <44E07A0C-5817-4F0A-A58E-87FC2627846D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 02:07:44PM -0600, Andreas Dilger wrote:
> On Jul 28, 2014, at 1:43 AM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> > Here is patchset with some fixes for journal code in e2fsprogs.
> > I've removed first patch from previous version "lib: add EXT2_ prefix for
> > SUPERBLOCK_{OFFSET,SIZE}", and rebase other patches on top of the maint branch.
> 
> Any reason you removed that first patch?  I thought the only negative
> feedback was because you renamed GFS_SUPERBLOCK_SIZE accidentally?

I don't want to make big changes like that until after we've released
1.43.0.

						- Ted
