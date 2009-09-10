From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 3/3] ext4: Clarify the locking details in mballoc
Date: Wed, 9 Sep 2009 23:53:30 -0400
Message-ID: <20090910035330.GB31907@mit.edu>
References: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com> <1252316294-10164-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59115 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZIJDxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 23:53:34 -0400
Content-Disposition: inline
In-Reply-To: <1252316294-10164-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 07, 2009 at 03:08:14PM +0530, Aneesh Kumar K.V wrote:
> We don't need to take the alloc_sem lock when we
> are adding new group. mballoc won't see the new
> group added untill we bump sbi->s_groups_count.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I've added your three resize/mballoc patches to the ext4 patch queue,
thanks.

					- Ted
