From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 2/4] ext4: fix error processing in mb_free_blocks
Date: Sun, 13 Jul 2008 21:07:56 -0400
Message-ID: <20080714010756.GB7938@mit.edu>
References: <200807130626.m6D6QKtc007910@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org, shen@cn.fujitsu.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46971 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753893AbYGNBIU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 21:08:20 -0400
Content-Disposition: inline
In-Reply-To: <200807130626.m6D6QKtc007910@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 12, 2008 at 11:26:20PM -0700, akpm@linux-foundation.org wrote:
> From: Shen Feng <shen@cn.fujitsu.com>
> 
> The error processing of the return value of mb_free_blocks is meanless
> because it only returns 0.  This fix includes
> 
> - make mb_free_blocks return void
> 
> - remove the error processing part in callers
> 
> - unlock group before calling ext4_error in mb_free_blocks
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thanks, applied.

						- Ted
