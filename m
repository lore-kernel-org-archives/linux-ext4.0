From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: re-inline ext4_rec_len_(to|from)_disk functions
Date: Thu, 5 Aug 2010 01:37:18 -0400
Message-ID: <20100805053718.GE2901@thunk.org>
References: <4C598CA5.70707@redhat.com>
 <20100805001116.GB2901@thunk.org>
 <4C5A05A4.9030701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35687 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab0HEFhX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 01:37:23 -0400
Content-Disposition: inline
In-Reply-To: <4C5A05A4.9030701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 04, 2010 at 07:28:20PM -0500, Eric Sandeen wrote:
> I had resisted doing that because at least the original rationale in
> the patch was for when the VM allows block size > page size ...

Well, that and apparently you can do completely insane/ludicrous page
sizes on the Itanic.  "The architecture supports 11 different page
sizes from 4k to 4GB."

> Side note, if you do this is PAGE_SIZE or PAGE_CACHE_SIZE the right macro?

Quite right, it should be PAGE_CACHE_SIZE (although I very much doubt
the two will be different any time in the near future).

    	     		      	      	       - Ted
