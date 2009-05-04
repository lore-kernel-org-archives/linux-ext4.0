From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Convert ext4_lock_group to use sb_bgl_lock
Date: Mon, 4 May 2009 07:39:31 -0400
Message-ID: <20090504113931.GB6766@mit.edu>
References: <1241312002-12598-1-git-send-email-tytso@mit.edu> <1241428267-13727-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46969 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbZEDLjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 07:39:46 -0400
Content-Disposition: inline
In-Reply-To: <1241428267-13727-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2009 at 02:41:07PM +0530, Aneesh Kumar K.V wrote:
> 
> This patch also change mb_set_bits from
> static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
> 
> to
> 
> static void mb_set_bits(int cur, void *bm, int len)
> 
> as per Andreas suggesion.

Could you separate this change out as a separate patch?  As Andreas'
pointed out, that really should be a separate change

Thanks!!

							- Ted
