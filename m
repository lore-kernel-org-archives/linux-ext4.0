From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Some interesting input from a flash manufacturer
Date: Tue, 6 Mar 2012 19:52:03 -0500
Message-ID: <20120307005203.GB5717@thunk.org>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
 <4F5135F0.6090100@redhat.com>
 <20120302231131.GE22215@thunk.org>
 <yq1mx7tk1rn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40362 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424Ab2CGQWm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 11:22:42 -0500
Content-Disposition: inline
In-Reply-To: <yq1mx7tk1rn.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 01:44:28PM -0500, Martin K. Petersen wrote:
> >>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:
> 
> Ted> As far as the /sys/block/XXX/queue/* framework, certainly.  It's
> Ted> not clear, however, whether or not we should use entirely new
> Ted> parameters, or try to reuse the existing parameters.  For example,
> Ted> would it be better to use optimal_io_size for the flash page size,
> Ted> or the erase block size?
> 
> If we were to use the existing fields we'd probably set min_io to the
> flash page size and optimal_io to the erase block size.

But min_io currently means the smallest size that we're allowed to
write, correct?  And the flash page size could be 128k and 512 byte
writes might be perfectly OK; it's just that writes are more optimal
at 128k, and would be even more optimal at the erbase block size of 4
megs.  That's why I'm not sure it makes sense to use the existing
fields, since it will confuse file system utilities that are reading
those fields.

   	     	       	       	      - Ted
