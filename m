From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] make all feature-related printks KERN_INFO and print
	barrier status as well
Date: Mon, 8 Sep 2008 17:10:47 -0400
Message-ID: <20080908211047.GN8161@mit.edu>
References: <48C55C0E.2050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62186 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbYIHVLE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2008 17:11:04 -0400
Content-Disposition: inline
In-Reply-To: <48C55C0E.2050809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2008 at 12:08:30PM -0500, Eric Sandeen wrote:
> A very trivial little tidy-up patch.
> 
> This slightly duplicates a little of
> patches/ext4_fix_printk_checkpatch_issues but just in one hunk,
> easily fixed up.
> 
> Various feature printk's come out at different levels, so for example
> at my default logging level I see mballoc & extents messages, but
> not delalloc, even though they are all on.
> 
> Also, since default barrier behavior has changed, I thought perhaps always
> printing the barrier state might be a good idea.

Looks good to me.  Any reason not to merge it with the
ext4_fix_printk_checkpatches_issues?  Actually what I was thinking
about doing was to segregate out all of the printk level issues from
everything else, just to make it easier to understand/audit the
cleanup patch(es).

							- Ted
