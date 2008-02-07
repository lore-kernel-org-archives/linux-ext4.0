From: Theodore Tso <tytso-DPNOqEs/LNQ@public.gmane.org>
Subject: Re: [PATCH 2/3] fsck: add support for the fsprobe library wrapper
Date: Thu, 7 Feb 2008 08:49:58 -0500
Message-ID: <20080207134958.GW27119@mit.edu>
References: <20080206113426.7833.59505.stgit@sor.suse.de> <20080206113902.7833.57924.stgit@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	msrex-l3A5Bk7waGM@public.gmane.org
To: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080206113902.7833.57924.stgit-qv7XSOoqp4Ab1SvskN2V4Q@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 06, 2008 at 12:39:02PM +0100, Matthias Koenig wrote:
> Allows fsck to work with blkid or volume_id as defined
> by the configure invocation.
> 
> Signed-off-by: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>

The big thing here is there needs to be a BIG FAT WARNING that if you
want ext4 to work, it's best to make sure fsck is built against the
very latest blkid library.

I was thinking about using opensuse for more of testing, based on
Markus's encouragement, but given that it's using vol_id, and I need
to make some very specific changes so that mount uses the right
filesystem for ext4 filesystems (especially since the kernel will be
changing the filesystem name from ext4dev to ext4 at some point in the
next few months), and opensuse uses vol_id for mount, that became a
show-stopper for me.

							- Ted
