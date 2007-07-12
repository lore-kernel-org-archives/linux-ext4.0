From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Random corruption test for e2fsck
Date: Thu, 12 Jul 2007 16:16:24 -0600
Message-ID: <20070712221624.GA5880@schatzie.adilger.int>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <p73myy3x8z0.fsf@bingen.suse.de> <20070712051938.GD5586@schatzie.adilger.int> <20070712110923.GA500@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:45436 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbXGLWQ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 18:16:27 -0400
Content-Disposition: inline
In-Reply-To: <20070712110923.GA500@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 12, 2007  13:09 +0200, Andi Kleen wrote:
> > "dd if=/dev/urandom bs=1k ..." than to spin in a loop getting 16-bit
> > random numbers from bash.  We would also be at the mercy of the shell
> > being identical on the user and debugger's systems.
> 
> With /dev/urandom you have the guarantee you'll never ever reproduce
> it again. 

That is kind of the point of this testing - getting new test images for
each user that runs "make check" or "make rpm".  I'm We also save the
generated image before e2fsck touches it so that it can be used for
debugging if needed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
