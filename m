From: Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 26 Sep 2007 16:54:31 -0600
Message-ID: <20070926225431.GY32520@schatzie.adilger.int>
References: <20070925153735.GA26693@infradead.org> <20070926105946.GB429@thunk.org> <20070926120533.GA15894@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070926120533.GA15894-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sep 26, 2007  13:05 +0100, Christoph Hellwig wrote:
> On Wed, Sep 26, 2007 at 06:59:46AM -0400, Theodore Tso wrote:
> > BTW, I don't like this syntax in the fstab file AT ALL, but it is in
> > use in the wild by at least some Fedora users, and it's not documented
> > in the fstab man page.  I'd suggest using a filesystem type of bind,
> > rather than ext3, as the officially "blessed" way of specifying it in
> > fstab, but it badly needs to be documented in the fstab and/or mount
> > man pages.  The above patch should probably get included, though, and
> > backwards compatibility for allowing "bind" to be specified in the
> > mount options, and with a warning message that the specifying "bind"
> > in the options field has been deprecated.
> 
> The syntax is indeed horrible.  Is it supported by upstream util-linux?

I think the issue is that if a filesystem is put into /etc/fstab with
type = "bind" then it will show up in /etc/mtab as "bind" and if the
original filesystem is unmounted the "mount" output will not show the
correct type anymore (I tested this with "bind" and "reiserfs" on an
ext3 filesystem).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
