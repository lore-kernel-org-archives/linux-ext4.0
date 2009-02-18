From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 18 Feb 2009 17:42:54 +0100
Message-ID: <20090218164254.GF7629@nb.net.home>
References: <20080206113426.7833.59505.stgit@sor.suse.de> <20070925153735.GA26693@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080206113426.7833.59505.stgit-qv7XSOoqp4Ab1SvskN2V4Q@public.gmane.org> <20070925153735.GA26693-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


 The fsck from the latest e2fsprogs git is util-linux-ng git now. It's
 possible to link it against libblkid (from e2fsprogs or
 util-linux-ng) and libvolume_id.

    Karel

On Tue, Sep 25, 2007 at 04:37:35PM +0100, Christoph Hellwig wrote:
> This adds fsck from latest e2fsprogs git to util-linux.  There are only

On Wed, Feb 06, 2008 at 12:38:59PM +0100, Matthias Koenig wrote:
> Here is another attempt to move fsck over to the util-linux-ng
> tree. A similar attempt has been done previously by Christoph
> Hellwig some time ago.

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
