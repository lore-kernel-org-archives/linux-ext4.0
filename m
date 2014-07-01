From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: Generated files in e2fsprogs git repo
Date: Tue, 1 Jul 2014 10:55:51 +0100
Message-ID: <CAJTo0Lb9cxfE4bt6qLXzg5C8_j-9MUtiE2se+PMbYSeE=Gjasw@mail.gmail.com>
References: <CAJTo0LYeerPnHpaxAw36N7BiWH4PKUMAX=1j+Szc7J9zvB7jjw@mail.gmail.com>
 <20140701010250.GA23932@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:64930 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaGAJ4M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 05:56:12 -0400
Received: by mail-qg0-f48.google.com with SMTP id q108so3152421qgd.35
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jul 2014 02:56:11 -0700 (PDT)
In-Reply-To: <20140701010250.GA23932@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1 July 2014 02:02, Theodore Ts'o <tytso@mit.edu> wrote:
> I don't trust autoreconf.  Different versions of autoconf can end up
> with different incompatible versions of autoconf macros, and I have
> seen some rather disastrous failures as a result.  That's why I update
> autoconf under my control, and if you run autoreconf as a user, and it
> breaks because the "archaic macros" work, and the "new shiny" macros
> fail, that's your problem, and I will laugh at you....

I disagree with this position: if you're the one releasing the
tarballs then you have this control anyway - people building from git
have a higher level of technical competence assumed and using the
right versions of autoconf isn't rocket science.

My context is that we're building distributions and for every package
that uses autotools we forcibly autoreconf because the
upstream-provided configure is generally insufficient: for example
upstream libtool needs patches to cross-compile correctly, and there's
a long lag (several years) between a new architecture being developed
(two recent examples: x32 and aarch64) and it being wide-spread enough
to be in every generated configure script.

e2fsprogs is one of the handful that breaks when we do this, because
aclocal.m4 contains macros that don't come from the system (AX_TLS and
CHECK_GNU_MAKE).  Simply moving these macros to acinclude.m4 should
solve this problem for us: autoconf defines that aclocal.m4 contains
copies of macros from the system, but acinclude.m4 contains
project-specific macros.  I'll send a patch shortly to implement this
split.

Ross
