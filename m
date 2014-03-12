From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Wed, 12 Mar 2014 16:51:10 -0400
Message-ID: <20140312205110.GF15334@thunk.org>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu>
 <20140312034539.GC26898@thunk.org>
 <20140312034841.GC31864@birch.djwong.org>
 <20140312143215.GA15334@thunk.org>
 <20140312200219.GC9070@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	liezhi.yang@windriver.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40597 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaCLUvN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 16:51:13 -0400
Content-Disposition: inline
In-Reply-To: <20140312200219.GC9070@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 01:02:19PM -0700, Darrick J. Wong wrote:
> > 
> > gcc -Wall, via "make gcc-wall" and "make gcc-wall-new"
> 
> Annoyingly, I ran make gcc-wall on Ubuntu 12.04 (gcc 4.6, glibc 2.15) and got
> this splat:
> 
> /usr/include/x86_64-linux-gnu/sys/stat.h:456: multiple definition of `stat'
> ../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:456: first defined here
> 
> Not sure how to fix this, other than changing WFLAGS to start with -std=gnu99.
> gcc 4.8/glibc 2.19 on Ubuntu 14 are no better.

Hmm, I'm using Debian testing, with gcc 4.8 and eglibc 2.18, and it's
working fine.  I'm curious, are people noticing problems with gcc-wall
on Fedora?

					- Ted
