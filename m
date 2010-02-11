From: tytso@mit.edu
Subject: Re: E2fsprogs 1.41.10 has been released
Date: Thu, 11 Feb 2010 11:54:14 -0500
Message-ID: <20100211165414.GJ739@thunk.org>
References: <E1NfLwx-00062Q-AX@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33638 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab0BKQyR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2010 11:54:17 -0500
Content-Disposition: inline
In-Reply-To: <E1NfLwx-00062Q-AX@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 10, 2010 at 06:26:27PM -0500, Theodore Ts'o wrote:
> Since Sourceforge has changed its File Release System, and no longer has
> a way of making announcements when a new release has gone out (and I
> don't know how many people were using it), I'll just make a quick
> announcement here.
> 
> E2fsprogs 1.41.10 has been released.  It can be found in the usual
> places (ftp.kernel.org, sourceforge), and of course in the e2fsprogs git
> repositories.

So Frank has pointed out to me that I screwed up the version.h file:

#define E2FSPROGS_DATE "10-Feb-2009"

*Sigh*

It's probably not worth spinning a new tar file, and confusing people
with two tarballs with different MD5 checksums, but if folks want to
fix this before releasing RPM's, et. al., please feel free to make the
obvious 's/2009/2010/' change.

						- Ted
