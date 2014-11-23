From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH 4/4] ext4: fix end of region partial cluster handling
Date: Sun, 23 Nov 2014 12:05:08 -0500
Message-ID: <20141123170508.GA2813@wallace>
References: <20141121145904.GE30246@wallace>
 <20141123060517.GC4102@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:54523 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaKWRFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Nov 2014 12:05:12 -0500
Received: by mail-qa0-f50.google.com with SMTP id w8so5414653qac.37
        for <linux-ext4@vger.kernel.org>; Sun, 23 Nov 2014 09:05:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20141123060517.GC4102@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The retry occurs at the end of ext4_ext_remove_space where the code loops
back to the top of the function if err == -EAGAIN, leading to another call
to ext4_ext_rm_leaf.  Nothing new needs to be added - we simply want to
avoid using invalid state to decide whether to free a partial cluster (on
occurrence of -EAGAIN), and the existing retry loop will eventually get us
valid state.

(I actually saw this in testing, but it takes a lot of runs to get there.)

Sorry if I edited down my comment a little too far - I'd be happy to beef
that up if desired.

Thanks,
Eric


* Theodore Ts'o <tytso@mit.edu>:
> On Fri, Nov 21, 2014 at 09:59:04AM -0500, Eric Whitney wrote:
> > ext4_ext_remove_space() can incorrectly free a partial_cluster if
> > EAGAIN is encountered while truncating or punching.  Extent removal
> > should be retried in this case.
> 
> I don't see anything in the patch below which retries the extent
> removal; am I missing something?
> 
> Thanks,
> 
> 						- Ted
