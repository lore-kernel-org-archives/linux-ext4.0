From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: misc: Remove broken whole device check
Date: Mon, 15 Jun 2015 00:05:42 -0400
Message-ID: <20150615040542.GE15793@thunk.org>
References: <1433198362-86983-1-git-send-email-ryao@gentoo.org>
 <74D84728-EFE7-4FF0-A99C-20F1F18EF8DF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Yao <ryao@gentoo.org>, linux-ext4@vger.kernel.org,
	Richard Yao <richard.yao@clusterhq.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35176 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbbFOEFo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 00:05:44 -0400
Content-Disposition: inline
In-Reply-To: <74D84728-EFE7-4FF0-A99C-20F1F18EF8DF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 01, 2015 at 04:56:45PM -0600, Andreas Dilger wrote:
> On Jun 1, 2015, at 4:39 PM, Richard Yao <ryao@gentoo.org> wrote:
> > 
> > From: Richard Yao <richard.yao@clusterhq.com>
> > 
> > Modern Linux major/minor numbering on block devices no longer conform to
> > the divisible by 64 rule for minor numbering. On my development system,
> > the correct number is 16. Consequently, this applies only to every 4th
> > drive on a modern system, which is inconsistent. That caused the
> > following bug to be filed against Flocker:
> > 
> > https://clusterhq.atlassian.net/browse/FLOC-2041
> > 
> > We could unconditionally pass -F to override this check whenever it
> > triggers, but that it would also override the libblkid check that
> > determines whether there are existing partitions, logical volumes or
> > filesystems on the disk, which seems unwise.
> > 
> > I propose that this check be removed because passing a whole disk to
> > mke2fs is a valid use case and given how long this has been broken,
> > users are already accustomed to the behavior where -F is not necessary
> > to format a whole disk as ext4.
> 
> I totally agree - we've been overriding this check for years, and
> I'm glad to see it go.  We have other mechanisms today to avoid
> users accidentally formatting the wrong device (O_EXCL, check for
> existing filesystems in interactive mode, etc.)
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
