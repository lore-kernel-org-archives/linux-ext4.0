From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Mon, 11 May 2009 23:08:56 -0400
Message-ID: <20090512030856.GI21518@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38837 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158AbZELDI7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 23:08:59 -0400
Content-Disposition: inline
In-Reply-To: <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2009 at 04:09:29PM +0530, Aneesh Kumar K.V wrote:
> ext4_get_blocks_wrap does a block lookup requesting to
> allocate new blocks. A lookup of blocks in prealloc area
> result in setting the unwritten flag in buffer_head. So
> a write to an unwritten extent will cause the buffer_head
> to have unwritten and mapped flag set. Clear hte unwritten
> buffer_head flag before requesting to allocate blocks.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I've rewritten the commit changelog to this, which I believe more
accurately describes the patch.  Comments, please?

ext4: Clear the unwritten buffer_head flag after the extent is initialized

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

The BH_Unwritten flag indicates that the buffer is allocated on disk
but has not been written; that is, the disk was part of a persistent
preallocation area.  That flag should only be set when a get_blocks()
function is looking up a inode's logical to physical block mapping.

When ext4_get_blocks_wrap() is called with create=1, the uninitialized
extent is converted into an initialized one, so the BH_Unwritten flag
is no longer appropriate.  Hence, we need to make sure the
BH_Unwritten is not left set, to avoid the ensuing confusion and
hilarty.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
