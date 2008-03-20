From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsprogs/pu has a conflict checked in
Date: Thu, 20 Mar 2008 16:21:31 -0400
Message-ID: <20080320202131.GN13719@mit.edu>
References: <47E12FF0.80906@redhat.com> <20080319161059.GM3158@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61618 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758067AbYCTUWN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 16:22:13 -0400
Content-Disposition: inline
In-Reply-To: <20080319161059.GM3158@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 19, 2008 at 12:10:59PM -0400, Theodore Tso wrote:
> On Wed, Mar 19, 2008 at 10:23:28AM -0500, Eric Sandeen wrote:
> > http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=lib/ext2fs/Makefile.in;h=1f5effa42d0f9c69458941bd75cde82940197a2f;hb=pu#l659
> > 
> > doesn't really build well that way ;)
> 
> Oops.  thanks for pointing that out.  Fortunately it's only on the pu
> branch...

Fixed now.

					- Ted
