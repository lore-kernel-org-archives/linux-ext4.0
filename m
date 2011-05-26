From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to specify if the caller can deal with ENOMEM
Date: Wed, 25 May 2011 22:07:20 -0600
Message-ID: <E4B2E5DC-AC13-4AB9-870E-6F3584991396@dilger.ca>
References: <4DDCAF18.8030809@gmail.com> <20110525074457.GA4427@quack.suse.cz> <4DDCB3FA.2070009@gmail.com> <20110525081333.GB4427@quack.suse.cz> <20110526022251.GG9520@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, Manish Katiyar <mkatiyar@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:52544 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab1EZEHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 May 2011 00:07:21 -0400
In-Reply-To: <20110526022251.GG9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 25, 2011, at 20:22, Ted Ts'o wrote:
> On Wed, May 25, 2011 at 10:13:33AM +0200, Jan Kara wrote:
>>> 
>>>  ok.. I will do it as a separate patch.
>> Well, patch 2/3 does not really make too much sense without it (errok
>> parameter isn't used) so there's no reason to do it as a separate patch.
>> Just add it to this patch please.
> 
> Agreed; right now this whole patch series is a no-op, since errok
> isn't getting used for anything.  So fixing errok so it's passed to
> start_this_handle() seems to be more in the category of "fix the
> patch" more than anything else.
> 
> One more thing; perhaps we should be passing in a integer so we can
> pass in a flag word.  That way you don't need to have a fail_ok
> variant.  It's a lot more obvious if you have a call:
> 
> 	  handle = ext4_journal_start(inode, 1, JBD2_FAIL_OK);
> 
> What we can also do is this:
> 
> 	  handle = ext4_journal_start(inode, 1, JBD2_FAIL_OK | JBD2_TOPLEVEL);
> 
> What JBD2_TOPLEVEL means is that caller is from a top-level file
> system function, such as ext4_symlink() or ext4_chmod(), such that
> start_this_handle() can use GFP_KERNEL instead of GFP_NOFS.  GFP_NOFS
> is needed for any function that might get called by the direct reclaim
> path (i.e., the writepage() function).  But for the top-level
> symlink() or chmod() function, it's actually OK to allocate memory
> using GFP_KERNEL, since there's no potential recursion problem.

At this point, why not just pass GFP_KERNEL or GFP_NOFS directly, optionally with __GFP_NOFAIL?


Cheers, Andreas





