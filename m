From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Tue, 31 Jul 2012 15:57:26 -0400
Message-ID: <20120731195726.GD32228@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120627112117.GA15231@thor.bakeyournoodle.com>
 <20120627125443.GA32356@thunk.org>
 <20120628024356.GB17989@thor.bakeyournoodle.com>
 <20120730214531.GE10343@thunk.org>
 <20120731052150.GB14970@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tony Breeds <tony@bakeyournoodle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42350 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2GaT5e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 15:57:34 -0400
Content-Disposition: inline
In-Reply-To: <20120731052150.GB14970@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 03:21:50PM +1000, Tony Breeds wrote:
> Thanks so much Ted for your help with my patches and the next set.
> 
> I tried next + your 7 patches and yaboot only fails with errors for
> calloc and abort.  Both of these I'm very happy to fix in yaboot.
> 
> Looking forward to v1.42.6 :)

Unfortunately, all of these changes put together were significant
enough that I didn't feel comfortable putting them in the 1.42.x
maintenance branch, especially since Debian is going through its
freeze process and I'm trying to get 1.42.5 into the release.  So I'm
being a lot more conservative about what sort of changes I'm allowing
into the maintenance branch at this point.

The 'master' and 'next' branches in git are targetting the 1.43
release of e2fsprogs.  If you need a tarball, and not just git tree
reference, I could cut a pre-release snapshot for testing purposes.  I
was planning on doing that soon for the metadata checksum and/or
inline data features in any case.

Regards,

						- Ted
