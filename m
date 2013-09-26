From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: Print a warning if running over a mounted
 filesystem
Date: Thu, 26 Sep 2013 19:56:58 -0400
Message-ID: <20130926235658.GD6011@thunk.org>
References: <1380229204-32526-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38714 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab3IZX5G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Sep 2013 19:57:06 -0400
Content-Disposition: inline
In-Reply-To: <1380229204-32526-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 26, 2013 at 06:00:04PM -0300, Carlos Maiolino wrote:
> Several users use to run e2image over a mounted filesystem, providing
> inconsistent, useless e2images.
> This patch adds a warning in such cases, notifying the user and also adds a
> force option making e2image able to run over Read-only filesystems.

It should be perfectly safe to run e2image on a read-only mounted file
system option, so it's not obvious to me why the force option would be
needed in that case.

Also, if we are saving a "normal" (not a raw or qcow) e2image file, we
are only backing up the statically located metadata blocks (i.e.,
superblock, block group descriptors, inode table, and allocation
bitmaps).  If we do this on a mounted file system, the e2image file is
less useful, but I'm not sure I'd call it completely useless.  If the
goal is to backup critical metadata, it will do that just fine.  So
maybe it's worthy of a warning, but I'm not sure it should require a
force option.

If the user is trying to capture a raw or qcow image file, I agree
that requiring that the file systme either be mounted read-only, not
mounted at all, or that a force option be specified, makes sense.

	   	   	  	       	  - Ted
