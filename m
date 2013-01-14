From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] resize2fs: add debug switch to use old online interface
Date: Mon, 14 Jan 2013 11:09:09 -0200
Message-ID: <20130114130909.GC3906@andromeda.usersys.redhat.com>
References: <50F05175.8060502@redhat.com>
 <20130112003027.GA9550@thunk.org>
 <50F0AF49.6010902@redhat.com>
 <20130112230427.GC19503@thunk.org>
 <20130114121049.GA3906@andromeda.usersys.redhat.com>
 <20130114125050.GA5907@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab3ANNJP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 08:09:15 -0500
Content-Disposition: inline
In-Reply-To: <20130114125050.GA5907@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 07:50:50AM -0500, Theodore Ts'o wrote:
> On Mon, Jan 14, 2013 at 10:10:49AM -0200, Carlos Maiolino wrote:
> > the patch looks good, but I'm very concerned about how much problems this will
> > cause to stable releases and enterprise products which use to work with older
> > kernel versions but a lot of backports of new features/bug fixes. Probably
> > upstream stable releases will not be too much affected giving these features
> > (new resize interface) might never be ported to stable kernels, but how about
> > the backporters? This mightl cause a lot of confusion when changing the
> > major/minor versions needed here.
> > 
> > IMHO, the new resize interface looks much better than the old one, and just
> > developers and users which do not have new interface should make use of the old
> > one. For developers I believe a resize2fs option is good enough to be used as
> > debug, and for users, well, if they do not have the new resize2fs, we should do
> > noting, once they'll use the old one automatically :-)
> 
> Well, this environment variable was intended only for developers who
> would be doing testing.  Note that I didn't bother to documenting both
> the older debugging environment variable, nor this new debugging
> environment variable.  It would problably be a good idea for me to
> write up the changes in the resize2fs interface (i.e., the new resize
> ioctl in 3.3, meta_bg / 64-bit resizing in 3.7) in the ext4 wiki, if
> for no other reason so that less sophisticated distributions _know_
> which commits they should back port so they can have a fully working
> resize2fs.  :-)
> 
> 						- Ted

This looks good for me, thanks =]
-- 
Carlos
