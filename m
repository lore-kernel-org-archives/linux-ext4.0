From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Generated files in e2fsprogs git repo
Date: Tue, 1 Jul 2014 11:22:33 -0400
Message-ID: <20140701152233.GA2775@thunk.org>
References: <CAJTo0LYeerPnHpaxAw36N7BiWH4PKUMAX=1j+Szc7J9zvB7jjw@mail.gmail.com>
 <20140701010250.GA23932@thunk.org>
 <CAJTo0Lb9cxfE4bt6qLXzg5C8_j-9MUtiE2se+PMbYSeE=Gjasw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Burton, Ross" <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39099 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbaGAPWg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jul 2014 11:22:36 -0400
Content-Disposition: inline
In-Reply-To: <CAJTo0Lb9cxfE4bt6qLXzg5C8_j-9MUtiE2se+PMbYSeE=Gjasw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 01, 2014 at 10:55:51AM +0100, Burton, Ross wrote:
> 
> My context is that we're building distributions and for every package
> that uses autotools we forcibly autoreconf because the
> upstream-provided configure is generally insufficient: for example
> upstream libtool needs patches to cross-compile correctly, and there's
> a long lag (several years) between a new architecture being developed
> (two recent examples: x32 and aarch64) and it being wide-spread enough
> to be in every generated configure script.

I don't use libtool at all, because I'm not a masochist.

	https://plus.google.com/+TheodoreTso/posts/89xgTY49Rvk

I assume the real issue is that you need an updated version of
config.guess and config.sub.  That can be easily updated without
having to use autoreconf, which is using an elephant gun to kill a
flea.

> e2fsprogs is one of the handful that breaks when we do this, because
> aclocal.m4 contains macros that don't come from the system (AX_TLS and
> CHECK_GNU_MAKE).  Simply moving these macros to acinclude.m4 should
> solve this problem for us: autoconf defines that aclocal.m4 contains
> copies of macros from the system, but acinclude.m4 contains
> project-specific macros.  I'll send a patch shortly to implement this
> split.

I'll look at that patch; if it's clean, I won't have a problem with
it.  But I'd strongly encourage you to consider just updating
config.guess and config.sub for those projects that have the good
taste not to use libtool.

Regards,

						- Ted
