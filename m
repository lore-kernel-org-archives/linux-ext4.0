From: "Kay Sievers" <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Thu, 7 Feb 2008 01:37:43 +0100
Message-ID: <3ae72650802061637t2185aaddt8a921c2fb3e8c097@mail.gmail.com>
References: <20080206113426.7833.59505.stgit@sor.suse.de>
	 <20080206125651.GD558@petra.dvoda.cz> <20080206140559.GJ27119@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Karel Zak" <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Matthias Koenig" <mkoenig-l3A5Bk7waGM@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Tso" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080206140559.GJ27119-3s7WtUTddSA@public.gmane.org>
Content-Disposition: inline
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Feb 6, 2008 3:05 PM, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org> wrote:
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

Care to explain what ext4 development has to do with the generic fsck program?
I don''t see any convincing reason not to move that now.

Kay
