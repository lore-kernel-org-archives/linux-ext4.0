From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't allow lg prealloc list to be grow large.
Date: Wed, 23 Jul 2008 14:13:27 -0400
Message-ID: <20080723181327.GA27683@mit.edu>
References: <1216833047-4959-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1216833047-4959-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1216833047-4959-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1216833047-4959-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38921 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbYGWSN4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 14:13:56 -0400
Content-Disposition: inline
In-Reply-To: <1216833047-4959-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2008 at 10:40:47PM +0530, Aneesh Kumar K.V wrote:
> Currently locality group prealloc list is freed only when there is a block allocation
> failure. This can result in large number of per cpu locality group prealloc space
> and also make the ext4_mb_use_preallocated expensive. Convert the locality group
> prealloc list to a hash list. The hash index is the order of number of blocks
> in the prealloc space with a max order of 9. When adding prealloc space to the
> list we make sure total entries for each order does not exceed 8. If it is more
> than 8 we discard few entries and make sure the we have only <= 5 entries.

So the second sentence made my english parser core dump.  :-)

I rewrote the patch comments as follows; is it still a fair summary?

    Currently, the locality group prealloc list is freed only when there
    is a block allocation failure. This can result in large number of
    entries in the preallocation list making ext4_mb_use_preallocated()
    expensive.
    
    To fix this, we convert the locality group prealloc list to a hash
    list. The hash index is the order of number of blocks in the prealloc
    space with a max order of 9. When adding prealloc space to the list we
    make sure total entries for each order does not exceed 8. If it is
    more than 8 we discard few entries and make sure the we have only <= 5
    entries.

							- Ted
