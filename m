From: tytso@mit.edu
Subject: Re: ext5
Date: Fri, 12 Feb 2010 11:02:43 -0500
Message-ID: <20100212160243.GQ739@thunk.org>
References: <20100210215028.GD739@thunk.org>
 <4B73931D.5000302@cox.net>
 <20100211064433.GF739@thunk.org>
 <874olnih62.fsf@frosties.localdomain>
 <4B74DD53.3080308@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46002 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0BLQCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Feb 2010 11:02:51 -0500
Content-Disposition: inline
In-Reply-To: <4B74DD53.3080308@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2010 at 10:47:15PM -0600, Ron Johnson wrote:
> On 2010-02-11 15:41, Goswin von Brederlow wrote:
> >tytso@mit.edu writes:
> >>The idea with read-only compressed files is that they are useful for
> >>large executables or large static files, where compressing them means
> >>that it takes less time to read them off of an HDD.
> >
> >Or when you only have so much flash.
> 
> Isn't that what squashfs is for?

The problem with the squashfs, fuse, ecryptfs approaches for the use
case that I am envisioning is that it's an all-or-nothing sort of
thing.  You may not want to encrypt all of the files in a file system.
Sure, you can play games with bind mounts, and/or accept the
performance hit of passing everything through fuse even for files that
aren't encrypted, but I think that's going to significantly inhibit
adoption of the technology.

Something which allows compressed and uncompressed files to co-exist
without any performance hits to the uncompressed files, and which
allows for a gradual transition after you upgrade rpm/dpkg and as
packages get upgraded is going to much easier time with adoption
rates.

							- Ted
