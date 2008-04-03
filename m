From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: #blocks per group too big: 37265
Date: Thu, 3 Apr 2008 15:12:54 -0400
Message-ID: <20080403191254.GG13486@mit.edu>
References: <20080403161904.GA31670@msgid.wurtel.net> <47F51AC6.6010205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49127 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbYDCTNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 15:13:20 -0400
Content-Disposition: inline
In-Reply-To: <47F51AC6.6010205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 03, 2008 at 12:58:30PM -0500, Eric Sandeen wrote:
> > I obtained the 1.39-tyt3 version of e2fsprogs, and did:

> > | mke2fs 1.38 (30-Jun-2005)

> I'd probably not use 1.39-tyt3... that's pretty old.  (see the 2005?) :)

Actually, e2fsprogs 1.39-tyt isn't that old (April 2007).  The 2005 is
because the mke2fs in use was 1.38, not 1.39.  (Which was probably
another problem.)

Which would be another problem.  As I mentioned, we will have a new
e2fsprogs release out soon.  What's in the git repository is probably
better than 1.39-tyt3 in most cases, but we want to fix a few final
things before we cut a 1.41-rc0 release.

						- Ted
