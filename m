From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add minimal resize size option
Date: Thu, 3 Jan 2008 12:21:01 -0500
Message-ID: <20080103172101.GE30771@mit.edu>
References: <20080102201659.GI31745@dhcp243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35894 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751907AbYACSJR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jan 2008 13:09:17 -0500
Content-Disposition: inline
In-Reply-To: <20080102201659.GI31745@dhcp243-37.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2008 at 03:16:59PM -0500, Josef Bacik wrote:
> Hello,
> 
> People wishing to make live usb disks and such are looking for a way
> to get the minimum resize size for an ext fs in blocks so that they
> can just resize their image to that size and do with it what they
> will.  This patch adds that functionality, just pass -m option and
> it calculates the minimum number of blocks the fs can be resized to.

Three comments.  Instead of using a new option, why not simply let
resize2fs check to see if the optional parameter is something like
"min" or "0"?

Secondly, I'd suggest factoring out the calculation of the minimal
size into a separate function.

Finally, please don't fix whitespace issues, as it makes it harder for me
to merge between the "maint" and "master" development lines.  What I
plan to do is to do a massive fixup of trailing whitespace before the
next major (1.41) release of e2fsprogs.  Any new lines added by
patches should not introduce any new trailing whitespace, of course.

Thanks!

						- Ted
