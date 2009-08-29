From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Fri, 28 Aug 2009 22:26:56 -0400
Message-ID: <20090829022656.GK16732@mit.edu>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48150 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZH2C07 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 22:26:59 -0400
Content-Disposition: inline
In-Reply-To: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:53:16AM +0530, Aneesh Kumar K.V wrote:
> Inorder to check whether the buffer_heads are mapped we need
> to hold page lock. Otherwise a reclaim can cleanup the attached
> buffer_heads. Instead of taking page lock and check whether
> buffer_heads are mapped we let the write_begin/write_end callback
> does the equivalent. It does have a performance impact in that we
> are doing more work if we the buffer_heads are already mapped.

So I started looking at all of the work that we need to do in
write_begin/write_end; did you check both write paths depending on
whether we are using delayed allocation or not?  It would seem to me
that it might be better to use lock_page() and unlock_page() around
the check, since in many work loads the buffer heads will already be
mapped often, and it appears to me that write_begin() will end up
locking the page anyway.

Am I missing something?

						- Ted
