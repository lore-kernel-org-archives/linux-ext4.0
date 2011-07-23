From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Fri, 22 Jul 2011 21:32:14 -0400
Message-ID: <20110723013214.GA22837@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
 <1311292237-4155-2-git-send-email-tytso@mit.edu>
 <20110722141753.GA19681@infradead.org>
 <20110722183048.GC25092@thunk.org>
 <20110722183830.GA21744@infradead.org>
 <20110722223458.GD25092@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36141
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711Ab1GWBcP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 21:32:15 -0400
Content-Disposition: inline
In-Reply-To: <20110722223458.GD25092@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 22, 2011 at 06:34:58PM -0400, Ted Ts'o wrote:
> Yes I needed it because I wanted to do a hermetic build; that is, I
> didn't want to depend on the version of the acl, attr, dmapi, etc.,
> shipped by the distribution.  (This is actually more important when
> building xfstests, since I wanted to make sure we used the version of
> the xfsprogs headers shipped by the very tip of xfsprogs-dev, since in
> the past I've had problems because the distro-shipped header files
> were too old.)

Given that you are on a Debian-ish environment, did you consider simply
using pbuilder?  I use that regularly to test clean package builds,
without all these weird overrides.

> The way I did that was by setting the environment CFLAGS to
> -I/kbuild/xfstests/bld/include.  And that seems to be the problem.  If
> CFLAGS is set as an environment variable, then it's set as a :=, which
> means that CFLAGS is set right away, the first time buildmacros is
> included.
> 
> How about this instead?  A patch like this so that CFLAGS can be
> remembered at configure time:
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 4c8ec64..81ebfcd 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
>  MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
> +CFLAGS = @CFLAGS@
>  
>  LIBRT = @librt@
>  LIBUUID = @libuuid@
> 
> Then I don't have to set an environment variable when running make; I
> just have to pass it to configure.

This looks much better, and is indeed similar to some other fixes we
recently had to put in, probably due to changing make behaviour.

If you add a signoff and a proper description I'll put it into all the
repositories.

