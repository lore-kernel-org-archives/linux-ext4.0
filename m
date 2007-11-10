From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH/RFC e2fsprogs] - replace MKINSTALLDIRS with MKDIR_P for
	newer autotools
Date: Sat, 10 Nov 2007 18:25:39 -0500
Message-ID: <20071110232539.GA12991@thunk.org>
References: <472F9148.1050405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, twoerner@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47007 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719AbXKKAly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Nov 2007 19:41:54 -0500
Content-Disposition: inline
In-Reply-To: <472F9148.1050405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 05, 2007 at 03:55:20PM -0600, Eric Sandeen wrote:
> From: Thomas Woerner <twoerner@redhat.com <mailto:twoerner@redhat.com>>
> 
> (Thomas was the original author of this patch)
> 
> I do not claim to be an autotools guru, hence the RFC.
> RH bugzilla #220715 claims that newer autoconf/automake no longer
> support MKINSTALLDIRS, and the changelog seems to confirm that, as
> does testing.  :)


MKINSTALLDIRS is defined in aclocal.m4, so we're good.  This patch
isn't necessary, as far as I can tell.  Have you actually shown that
with some newer version of autoconf, it produces a configure script
which doesn't define MKINSTALLDIRS?  As far as I know e2fsprogs builds
Just Fine, and using autoconf 2.61 isn't a problem.

What version of autoconf are you using that triggers this problem?
(Note that e2fsprogs does not use automake, since automake is a
horrible kludge of backwards non-compatibility and ugliness....)

At some point when we go to a newer version of gettext we may need to
update things, but I'd much rather save that for when we really uplift
gettext and aclocal.m4 all in one go.

For now, I suspect you could drop this patch without any problems,
since we don't use automake, and aclocal.m4 has a version of
AM_MKINSTALLDIRS that will do the right thing.

Regards,

						- Ted
