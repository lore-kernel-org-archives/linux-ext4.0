From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2 for 2.6.31] ext4: Use -1 as the fake block number
	for delayed new buffer_head
Date: Fri, 1 May 2009 18:59:25 -0400
Message-ID: <20090501225925.GI7681@mit.edu>
References: <1241003611-3652-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090501185841.GG7681@mit.edu> <20090501190546.GA920@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42765 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZEAW7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 18:59:32 -0400
Content-Disposition: inline
In-Reply-To: <20090501190546.GA920@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 02, 2009 at 12:35:46AM +0530, Aneesh Kumar K.V wrote:
> On Fri, May 01, 2009 at 02:58:41PM -0400, Theodore Tso wrote:
> > You mean "for 2.6.30", right?
> > 
> 
> The reason for me to post two series one for 2.6.30 and other for 2.6.31
> was the [Patch 2/2] for 2.6.31 needs more testing. I added this specific
> patch in both the series to make sure  we don't miss the change in case
> we decided not to make any changes for 2.6.30. Also in my testing I created
> different topgit branches with different dependencies. So having [PATCH
> 1/2 ] in both the series helped in testing with topgit branches.

Yeah, but you didn't label the other series as "for 2.6.30".  To makes
matter worse, the fact that patch #2 in what I think is your 2.6.30
patch series (the V4 series?) is the same as patch #1 of your 2.6.31
series, and your "2.6.31" series doesn't have a patch backing out the
2.6.30 changes (I assume you need to do that, right?), left me as a
very confused maintainer about. 

OK, so what I have in the patch queue is the V4 version, somewhat
modified, and I'll ignore the "for 2.6.31" patches for now.  When
you're ready, please send me patches versus the end of the stable
series of the ext4 patch queue, and please give me this kind of
context.

If you could verify what's in the patch queue, I'd appreciate it.

Thanks,

						- Ted
