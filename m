From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Fix the delalloc writepages to allocate
	blocks at the right offset.
Date: Wed, 26 Nov 2008 00:53:21 -0500
Message-ID: <20081126055321.GF1410@mit.edu>
References: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, vallesroc@gmail.com,
	Solofo.Ramangalahy@bull.net, cryptooctoploid@gmail.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49914 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752148AbYKZFxh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 00:53:37 -0500
Content-Disposition: inline
In-Reply-To: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 03:12:27PM +0530, Aneesh Kumar K.V wrote:
> When iterating through the pages with all mapped buffer_heads
> we failed to update the b_state value. This result in allocating
> blocks at logical offset 0.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Hey Aneesh,

I've been going through patches in the patch queue and I noticed that
the subsequent patch 

[PATCH 2/2] ext4: Mark the buffer_heads as dirty and uptodate after prepare_write

has been merged to mainline, but this one wasn't.  From looking at the
e-mail record, you said that the second one fixed the rtorrent
corruption --- but looking at this patch and its description, it looks
like this one should perhaps get pushed to Linus ASAP as well.  Do you
remember if both patches were needed to fix the rtorrent corruption
problem, or only the second one?

Thanks,

						- Ted
