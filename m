From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Wed, 6 Feb 2008 16:23:10 +0100
Message-ID: <20080206152310.GF558@petra.dvoda.cz>
References: <20080206113426.7833.59505.stgit@sor.suse.de> <20080206125651.GD558@petra.dvoda.cz> <20080206140559.GJ27119@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-DPNOqEs/LNQ@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080206140559.GJ27119-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 06, 2008 at 09:05:59AM -0500, Theodore Tso wrote:
> On Wed, Feb 06, 2008 at 01:56:51PM +0100, Karel Zak wrote:
> > It would be nice to add a note
> > 
> >     "fsck is deprecated in favor of fsck from util-linux-ng"
> > 
> > to RELEASE-NOTES in e2fsprogs.
> 
> I don't want to deprecate fsck quite yet from e2fsprogs, because there
> are some ext4 issues with fsck (or more accurately, fsck's use of
> vol_id instead of blkid), where it is more convenient if at least for
> distros that are being aggressive with ext4 testing, if we don't try
> to move fsck just now.

 That's nothing urgent for me.

 No problem to postpone this change until util-linux-ng 2.15 (at end
 of this year). I believe ext4 will be pretty stable at this time :-)

> I'd love to try to work on merging the functionality between vol_id
> and blkid, and at some point that's great, but I just don't have the
> time right now to try to coordinate yet another moving part.

 I'm already working on vol_id + blkid merge

    http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/fsprobe

 My plan is follow ideas and code from blkid and add a new low-level API
 for udev. That's all.

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
