From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Wed, 23 Jan 2008 11:53:07 -0500
Message-ID: <20080123165307.GA32663@mit.edu>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63964 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYAWQxu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 11:53:50 -0500
Content-Disposition: inline
In-Reply-To: <4796BAB9.7000502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2008 at 09:55:37PM -0600, Eric Sandeen wrote:
> 
> Overall, seems ok.  One other question though, when ext4 is a
> fully-fledged production filesystem, and the flag requirement is gone,
> what stops ext3 filesystems from being silently mounted as ext4, just as
> happened with ext4dev today?  

Nothing will prevent that, but in the long term we don't want ext4 to
be automatically adding new features flags anyway.  The only reason
why we were doing that was to encourage more people to test out ext4,
and for the convenience of the ABAT auto-testing.

So I'm assuming that before we remove this test, we will also be
fixing some of the automatic enablement of extents, etc., because that
sort of thing will be moved into e2fsprogs as part of "tune2fs -O
ext4" or "mke2fs -O ext4" or "mkfs.ext4". 

If we do that, then the only downside of having ext3 filesystems run
under ext4 is the test matrix concern.  Since I'm still hoping that
some point in the future, fs/ext4 could subsume fs/ext3 so we don't
have to worry about bug fixes going into fs/ext2 AND fs/ext3 AND
fs/ext4, I have my own reasons for wanting that.  But I do understand
the concerns that maybe in the short term some distro's don't want to
do that.  So in that case I could see adding a "you must have extents"
test into ext4, if I distro has specific support concerns. But for
people who are running mainline kernel, I think it's actually a *good*
thing if fs/ext4 can mount and read and write to an ext3 filesystem
--- as long as it doesn't automatically turn on features behind the
user's back.

> +			"\ttestfs\n"));
> 
> help text doesn't match reality here, missing a "_"

Oops, thanks for catching that.

						- Ted
