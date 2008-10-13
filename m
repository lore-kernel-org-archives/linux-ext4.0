From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Free ext4_prealloc_space using kmem_cache_free
Date: Mon, 13 Oct 2008 12:41:32 -0400
Message-ID: <20081013164132.GC17792@mit.edu>
References: <1223914443-25000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59754 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134AbYJMQls (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 12:41:48 -0400
Content-Disposition: inline
In-Reply-To: <1223914443-25000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 09:44:03PM +0530, Aneesh Kumar K.V wrote:
> We should use kmem_cache_free to free memory allocated
> via kmem_cache_alloc

Thanks, queued.

						- Ted
