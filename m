From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] off-by-one in "Add checks to validate extent entries."
Date: Sat, 4 Apr 2009 23:24:38 -0400
Message-ID: <20090405032438.GI7553@mit.edu>
References: <49D4F217.7050105@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54152 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbZDEEJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Apr 2009 00:09:40 -0400
Content-Disposition: inline
In-Reply-To: <49D4F217.7050105@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2009 at 07:12:55PM +0200, Thiemo Nagel wrote:
> Theodore Tso wrote:
> > I haven't had time yet to check your other patches; could you also
> > take a quick scan to make sure we have all of the byte-swapping calls
> > needed for proper big-endian checking, that we're using the correct
> > __le32 types and not doing any casts?
>
> I had a look at all patches I have sent, but I didn't notice anything  
> suspicious.  While doing that, however I think I found an off-by-one in
> 56b19868aca856a7d7bf20c3a7a1030e4fd75b2b

In the future, could you please remember to include a Signed-off-by:
for your patches?

Thanks!!

This one is simple enough that I'll just include it, but I'd really
prefer to get explicit signed-off patches.

						- Ted
