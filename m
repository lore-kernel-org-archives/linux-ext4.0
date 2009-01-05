From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
 WBC_SYNC_ALL
Date: Mon, 5 Jan 2009 10:47:13 -0800
Message-ID: <20090105104713.78fdabc9.akpm@linux-foundation.org>
References: <E1LJatq-00061O-0e@closure.thunk.org>
	<20090104142303.98762f81.akpm@linux-foundation.org>
	<20090104224351.GF22958@mit.edu>
	<20090104151927.1f1603c6.akpm@linux-foundation.org>
	<20090105080241.GX32491@kernel.dk>
	<20090105144740.GA4116@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZAESrn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 13:47:43 -0500
In-Reply-To: <20090105144740.GA4116@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 Jan 2009 09:47:40 -0500 Theodore Tso <tytso@mit.edu> wrote:

> there will be times (i.e., when we are doing a checkpoint as
> opposed to a commit, or in a fsync-heavy workload), where we will end
> up getting blocked behind kjournald, so upping the I/O priority really
> does make sense.

Not if it will cause kjournald writes to be prioritised ahead of any
reads, I suspect.  Writes are rarely synchronous, but with reads,
there's almost always someone waiting.

