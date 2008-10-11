From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use an rb tree for tracking blocks freed during
	transaction.
Date: Sat, 11 Oct 2008 00:27:38 -0400
Message-ID: <20081011042738.GC8145@mit.edu>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43477 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbYJKE1w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 00:27:52 -0400
Content-Disposition: inline
In-Reply-To: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 09:02:07PM +0530, Aneesh Kumar K.V wrote:
> With this patch we track the block freed during a transaction using
> rb tree. We also make sure contiguos blocks freed are collected
> in one rb node.

Thanks, I've added your recent set of patches to the ext4 patch queue.
I'm pretty sure I grabbed the correct (most recent) patches from the
mailing list, but please double check for me.

Thanks!!

						- Ted
