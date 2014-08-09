From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Sat, 9 Aug 2014 00:07:36 -0400
Message-ID: <20140809040736.GB23604@thunk.org>
References: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
 <20140808214732.GN25145@thunk.org>
 <BLU436-SMTP222E1BBA304D4F1F10EC4A6FDEE0@phx.gbl>
 <20140809002131.GR25145@thunk.org>
 <BLU436-SMTP1726DA8B9CB511781B73155FDEF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51954 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaHIEHj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 00:07:39 -0400
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP1726DA8B9CB511781B73155FDEF0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 11:29:11PM -0400, TR Reardon wrote:
> 
> I meant only: that commit is in master _and_ maint branches, so to get a
> version roughly = 1.42.11 + metadata_csum, I pulled up to that commit.

Right but you gave me the git commit id for 1.42.11, which is not
particularly useful; I know the commit id for v1.42.11 already.  :-)

What I needed to know was the git commit of "master" that you had
grabbed, since the "master" and "next" branches are fairly active
these days.  (The master branch langs the next branch, so depending on
how exciting a life you want to live, you can try the next branch
instead of the master branch.)

> Regardless, the problem exists in kernel too, judging by the JBD2 errors.

Yes, we'll need to look into that.  Definitely worth knowing; thanks
for that.

Cheers,

					- Ted
