From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: allow do_write() to handle files over 4GB
Date: Sat, 26 Jul 2014 14:40:41 -0400
Message-ID: <20140726184041.GG6725@thunk.org>
References: <1406245759-1617-1-git-send-email-adilger@dilger.ca>
 <20140725000431.GI8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58319 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaGZSkn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 14:40:43 -0400
Content-Disposition: inline
In-Reply-To: <20140725000431.GI8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 05:04:31PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 24, 2014 at 05:49:19PM -0600, Andreas Dilger wrote:
> > Fix debugfs do_write() to correctly set i_size_high if the source
> > file is larger than 4GB.  Otherwise, only the low 32 bits of the
> > size is stored in i_size.
> 
> You might also want to set large_file if needed.  I wrote a helper to set an
> inode's i_size* fields and turn on feature bits; it's been languishing at the
> back end of the patchbomb for a while:
> http://permalink.gmane.org/gmane.comp.file-systems.ext4/43861

I've pulled in a slightly modified version of Darrick's patch, which
takes care of this issue.

							- Ted
