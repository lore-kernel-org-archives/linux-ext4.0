From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Wed, 27 Mar 2013 09:46:06 -0400
Message-ID: <20130327134606.GJ5861@thunk.org>
References: <5152F2BB.4000709@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Rich Johnston <rjohnston@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56328 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3C0NqJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 09:46:09 -0400
Content-Disposition: inline
In-Reply-To: <5152F2BB.4000709@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 08:23:07AM -0500, Rich Johnston wrote:
> All xfstest developers,
> 
> Thanks again for all your time in submitting and reviewing patches
> for xfstests.  The latest patchset posted here:
> 
> http://oss.sgi.com/archives/xfs/2013-03/msg00467.html
> 
> requires all current patches to be re-factored.

Given that we are now segregating patches into subdirectories, is it
correct in the future tests should be named descriptively, instead of
using 3 digit NNN numbers (which has been a major pain from a central
assignment perspective)?

If so, is there a suggested naming convention that is being recommended?

Thanks for getting this change merged in!!

					- Ted
