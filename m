From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented
 byteswapping routines
Date: Mon, 14 Jan 2013 09:20:05 -0500
Message-ID: <20130114142005.GC12052@thunk.org>
References: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org>
 <20130114141356.GA12052@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43274 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab3ANOUH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 09:20:07 -0500
Content-Disposition: inline
In-Reply-To: <20130114141356.GA12052@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 09:13:56AM -0500, Theodore Ts'o wrote:
> The problem is that bswap_{16,32,64}() and the existence of
> <byteswap.h> is not guaranted by any standard that I'm not aware of.
> A quick Google search indicates that it's not available for the
> following platforms....

P.S.  This "all the world's a Linux platforms" attitude is why a lot
of people are very snide about how many Linux userspace programmers
will introduced vast bloated, slow, infuriating autoconf and automake
infrastructure, and then use Linux'isms that completely break all
portability for anything other than Linux systems....  at which point,
why bother using autoconf and automake?

	    		       	    	  - Ted
