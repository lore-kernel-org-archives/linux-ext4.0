From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest generic/020 failure on nojournal in ext4 dev branch
Date: Tue, 1 Apr 2014 19:40:06 -0400
Message-ID: <20140401234006.GA21410@thunk.org>
References: <20140401212043.GA2165@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48733 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbaDAXkl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 19:40:41 -0400
Content-Disposition: inline
In-Reply-To: <20140401212043.GA2165@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 01, 2014 at 05:20:43PM -0400, Eric Whitney wrote:
> I'm seeing a problem in the dev branch when running xfstests on a non-journaled
> filesystem.  (All the other xfstests-bld scenarios are looking good in
> comparison with my 3.14 baseline.)
> 
> The test in question is generic/020, and it simply causes a BUG (null pointer
> dereference) that stops the test run.  Tip of my dev branch is 2c74cd642a.
> The last commits on there look like possible candidates given the stack trace.

Thanks for noticing this!

It was caused by a patch hunk in the patch each-fs-uses-its-own-mbcache
landing in the wrong place.  I've fixed up the patch and pushed out an
updated dev branch.

					- Ted
