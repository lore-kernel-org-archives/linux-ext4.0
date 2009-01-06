From: Theodore Tso <tytso@mit.edu>
Subject: Re: New ext4 patchset: 2.6.28-ext4-2
Date: Tue, 6 Jan 2009 13:26:38 -0500
Message-ID: <20090106182638.GD10903@mit.edu>
References: <E1LK5Ws-00076Z-7D@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43044 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbZAFS0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 13:26:40 -0500
Content-Disposition: inline
In-Reply-To: <E1LK5Ws-00076Z-7D@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 06, 2009 at 01:35:06AM -0500, Theodore Ts'o wrote:
> 
> This is an update of the draft set of patches which I hope to be able to
> push to Linus shortly, after a tad bit more testing.

Note; there is a serious bug in 2.6.28-ext4-2 due to a typo on my
part; said typo disables journalling entirely on ext4 filesystems.
Oops.  My bad; there was a missing "else" what should have read:

+      } if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&

So please don't use 2.6.28-ext4-2.  I will be releasing a
2.6.28-ext4-3 to fix this up, as well as one or two other problems and
documentation fix ups.

					- Ted
