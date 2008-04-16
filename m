From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Wed, 16 Apr 2008 11:26:14 +0200
Message-ID: <20080416092614.GA6116@duck.suse.cz>
References: <20080415161430.GC28699@duck.suse.cz> <1208282305.18386.67.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56974 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbYDPJ0Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2008 05:26:16 -0400
Content-Disposition: inline
In-Reply-To: <1208282305.18386.67.camel@badari-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-04-08 10:58:25, Badari Pulavarty wrote:
> 
> On Tue, 2008-04-15 at 18:14 +0200, Jan Kara wrote:
> > Hi,
> > 
> >   I've ported my patch inversing locking ordering of page_lock and
> > transaction start to ext4 (on top of ext4 patch queue). Everything except
> > delayed allocation is converted (the patch is below for interested
> > readers).
> 
> I am curious on the following code:
> 
> ext4_ordered_writepage()
> 
> + * Note that we don't need to start a transaction unless we're journaling
> + * data because we should have holes filled from ext4_page_mkwrite(). If
> + * we are journaling data, we cannot start transaction directly because
> + * transaction start ranks above page lock so we have to do some magic...
  Hmm, actually this comment becomes completely correct only after JBD
ordered mode rewrite patch ;). But the locking is correct even now - note
that we call block_write_full_page() before we start a transaction and
block_write_full_page() unlocks the page...

> Currently you are starting a transaction when the page is locked. 
> What do you plan to do here ?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
