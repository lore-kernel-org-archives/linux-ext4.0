From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Mon, 11 Mar 2013 17:22:39 -0400
Message-ID: <20130311212239.GD15478@thunk.org>
References: <20130311185423.GA15478@thunk.org>
 <20130311210201.GA940@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52647 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3CKVWl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 17:22:41 -0400
Content-Disposition: inline
In-Reply-To: <20130311210201.GA940@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 05:02:01PM -0400, Eric Whitney wrote:
> 
> FWIW, this might not be a regression.  I believe I've got this warning in my
> testing logs from both 3.8 and 3.8-rc7 (commit 01a523eb51 in 3.9-rc1 affects
> message format and line numbering) on both x86 and ARM.  I didn't run xfstest
> 127 prior to 3.8-rc7, so I don't know how far back the warning may have
> occurred for that particular test.
> 
> The 3.8-rc7 results are a little different with respect to number of warnings
> and test cases, so I'm thinking this one isn't completely deterministic,
> testing-wise.  Multiple test runs may be required to see it.

Thanks for the extra data; this saved be a whole bunch of time, since
I probably would have started doing a series git bisects tonight.   :-)

  	   	      	      	      - Ted

