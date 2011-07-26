From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Tue, 26 Jul 2011 11:10:33 -0400
Message-ID: <20110726151033.GA18311@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
 <1311292237-4155-2-git-send-email-tytso@mit.edu>
 <20110722141753.GA19681@infradead.org>
 <20110722183048.GC25092@thunk.org>
 <20110722183830.GA21744@infradead.org>
 <20110722223458.GD25092@thunk.org>
 <20110723013214.GA22837@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37961
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab1GZPKg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 11:10:36 -0400
Content-Disposition: inline
In-Reply-To: <20110723013214.GA22837@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 22, 2011 at 09:32:14PM -0400, Christoph Hellwig wrote:
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 4c8ec64..81ebfcd 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
> >  MALLOCLIB = @malloc_lib@
> >  LOADERFLAGS = @LDFLAGS@
> >  LTLDFLAGS = @LDFLAGS@
> > +CFLAGS = @CFLAGS@
> >  
> >  LIBRT = @librt@
> >  LIBUUID = @libuuid@
> > 
> > Then I don't have to set an environment variable when running make; I
> > just have to pass it to configure.
> 
> This looks much better, and is indeed similar to some other fixes we
> recently had to put in, probably due to changing make behaviour.
> 
> If you add a signoff and a proper description I'll put it into all the
> repositories.

Can you at least provide the signoff?  I can take care of the rest if
this means I can get it in ASAP.

