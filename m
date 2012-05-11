From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Fri, 11 May 2012 12:46:05 -0400
Message-ID: <20120511164605.GC6467@thunk.org>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
 <20120511034945.GA15892@mobil.systemanalysen.net>
 <4FAD2161.3090108@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
To: Rob Landley <rob@landley.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34088 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab2EKQqO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 May 2012 12:46:14 -0400
Content-Disposition: inline
In-Reply-To: <4FAD2161.3090108@landley.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 11, 2012 at 09:25:37AM -0500, Rob Landley wrote:
> Well it's certainly a point of view. Luckily, FAT already _has_ the
> workaround we're discussing.  The objections were mainly "can't the VFS
> do this for us?" and the answer, upon closer inspection, turned out to
> be "not easily, no, the VFS takes option flags instead of parsing string
> options so doesn't have some necessary infrastructure".

The only reasonable use case I can imagine for this feature is one
where someone wants to use a removable storage device (which could be
a USB thumb drive to a USB HDD to a SSD in a USB 3.0 enclosure) as an
interchange device between Unix systems which do not have compatible
uid/gid spaces.

So perhaps the right approach is that we should have an ext2/3/4
read-only feature flag which enforces a default of nosuid and all
files to be read-only and world-readable.  There would be mount
options which could modify this default behaviour so that the files
could be writeable by a particular uid or gid, and another mount
option which would change the permission bits seen for that file
system from 0755/0644 for directories/files to 0700/0600.

Basically, the idea is we should mark the file system in an explicit
way that it is intended for interchange across incompatible uid/gid
spaces, with defaults which minimize security risk.  The fact that all
files become world-readable is potentially a risk, but if the user is
willing to put their private files on a removeable media that could
easily be dropped in a parking lot, or otherwise stolen or lost,
that's a potential risk that they've implicitly accepted in any case;
we might as well make it be explicit.

							- Ted

