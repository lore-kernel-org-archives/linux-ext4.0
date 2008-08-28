From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4] Create the journal in the middle of the filesystem
Date: Thu, 28 Aug 2008 10:36:48 -0400
Message-ID: <20080828143648.GJ26987@mit.edu>
References: <20080827210636.GC26987@mit.edu> <1219871676-18456-1-git-send-email-tytso@mit.edu> <1219871676-18456-2-git-send-email-tytso@mit.edu> <1219917321.3591.79.camel@frecb007923.frec.bull.fr> <20080828133449.GG26987@mit.edu> <48B6AACE.6060103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43900 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752833AbYH1OhN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 10:37:13 -0400
Content-Disposition: inline
In-Reply-To: <48B6AACE.6060103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 09:40:30AM -0400, Ric Wheeler wrote:
>
> I can try and test this with my fsync() heavy fs_mark run...
>

Given [1] I have no doubt that you should see a difference between
mke2fs from e2fsprogs 1.41.0 (which will allocate the journal at the
beginning of the filesystem) and the latest tip of e2fsprogs.

It would be interesting to see how measurable the difference is,
though.  I'd recommend doing "mke2fs -t ext4dev" using both versions
of mke2fs, and seeing how much the difference it makes.

[1] http://www.usenix.org/events/usenix05/tech/general/full_papers/prabhakaran/prabhakaran_html/main.html#fig-journal-location-withinfs-fix

							- Ted

