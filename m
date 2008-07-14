From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 3/4]
	jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-comm
	it-transaction-cleanup
Date: Sun, 13 Jul 2008 21:08:17 -0400
Message-ID: <20080714010817.GC7938@mit.edu>
References: <200807130626.m6D6QL7E007913@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org, pbadari@us.ibm.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46973 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754085AbYGNBIU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 21:08:20 -0400
Content-Disposition: inline
In-Reply-To: <200807130626.m6D6QL7E007913@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 12, 2008 at 11:26:21PM -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> unneeded initialisation.
> 

Thanks, I've folded this into the existing patch.

							- Ted
