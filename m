From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Fri, 22 Feb 2008 11:33:31 -0500
Message-ID: <20080222163331.GQ20118@mit.edu>
References: <47BDF6C9.8090009@redhat.com> <20080222131622.GK20118@mit.edu> <47BEE420.8030105@redhat.com> <20080222154404.GP20118@mit.edu> <47BEF575.40908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	pspencer@fields.utoronto.ca
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57005 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761330AbYBVQe6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 11:34:58 -0500
Content-Disposition: inline
In-Reply-To: <47BEF575.40908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 10:16:53AM -0600, Eric Sandeen wrote:
> From a quick chat with agk, it sounds like outright failure is
> appropriate.  Sounds like most of the calls fail for reasons like ENOMEM
> (but it might be nice if it returned that, eh?)

So the question then is why is it that Phillip was able to seeing
failures when he was creating and deleting snapshots?

I don't mind having blkid return a failure, but it may not fix
Phillip's scenario which he listed in BZ #433857; yeah, he won't have
a core dump, which is good, but it might mean that some or all of the
dm volumes disappear from the blkid results.

							- Ted
