From: Theodore Tso <tytso@mit.edu>
Subject: Re: next-20090206: deadlock on ext4
Date: Wed, 18 Feb 2009 08:04:19 -0500
Message-ID: <20090218130418.GB3600@mini-me.lan>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com> <498C7671.1050309@redhat.com> <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com> <498C9876.3060208@redhat.com> <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com> <4995F27E.3070401@redhat.com> <a4423d670902180156yd293319na51f91c6651e076c@mail.gmail.com> <20090218101218.GR19388@charite.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57515 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZBROBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 09:01:32 -0500
Content-Disposition: inline
In-Reply-To: <20090218101218.GR19388@charite.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 18, 2009 at 11:12:18AM +0100, Ralf Hildebrandt wrote:
> > Yes, it works, I can not reproduce the bug on
> > 2.6.29-rc5-00122-g5955c7a which contains 2acf2c261b82
> > "ext4: Implement range_cyclic in ext4_da_writepages instead of
> > write_cache_pages"
> 
> Will there be a backport for 2.6.28.x ?
> I'm suffering here.

The patch just hit mainline, so yes, I'll get a backport series set up.

    	       	   	     	     	  - Ted
