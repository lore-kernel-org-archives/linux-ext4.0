From: tytso@mit.edu
Subject: Re: [PATCH] ext4/super.c: Fix error in ext4_fill_super:
 ext3_fs_type undeclared (first use in this function)
Date: Wed, 24 Mar 2010 12:13:08 -0400
Message-ID: <20100324161308.GH2159@thunk.org>
References: <2d0a357f1003240445y27e9e56ete60d0786f42ac486@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60889 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab0CXQN3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 12:13:29 -0400
Content-Disposition: inline
In-Reply-To: <2d0a357f1003240445y27e9e56ete60d0786f42ac486@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 24, 2010 at 12:45:27PM +0100, Sedat Dilek wrote:
> Not sure if this is really fixing the problem in [1].

Yeah, that should fix it, but see the patch I sent just a moment
ago... (sorry, I didn't see your e-mail until I checked in my fix...)

       	       	 	    	 	- Ted
