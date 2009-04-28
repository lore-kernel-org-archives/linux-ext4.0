From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Tue, 28 Apr 2009 22:36:35 +0200
Message-ID: <20090428203635.GA3793@nb.net.home>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <20090427092114.GA3193@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52536 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZD1Ugm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 16:36:42 -0400
Content-Disposition: inline
In-Reply-To: <20090427092114.GA3193@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 27, 2009 at 11:21:14AM +0200, Karel Zak wrote:
> On Wed, Apr 22, 2009 at 09:33:04AM -0400, Theodore Tso wrote:
> > This is the version of the the --disable-libblkid patch which I
> 
> [...]
> 
> > The changes have been pushed out to the e2fsprogs git repository if
> > you want to try it out with the latest changes, which will be in the
> > very-soon-to-be-released e2fsprogs 1.41.5.
> 
>  Thanks!
> 
>  I forgot that we need to freeze blkid version number in e2fsprogs to
>  avoid collisions between e2fsprogs and util-linux-ng. Currently the
>  blkid version number is shared with e2fsprogs version number. 

 It seems we can ignore this problem for now. I can release
 libblkid 2.15 (=util-linux-ng version) and keep the same SONAME as
 you have in e2fsprogs -- it means soname "libblkid.so.1".

 It seems people prefer the same version for library as well as for
 whole package.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
