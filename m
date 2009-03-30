From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: Avoid false EIO errors
Date: Mon, 30 Mar 2009 20:15:23 +0530
Message-ID: <20090330144523.GA14489@skywalker>
References: <1238091711-23464-1-git-send-email-jack@suse.cz> <20090327180806.GB2810@skywalker> <20090327202421.GB31071@duck.suse.cz> <20090330082532.GA15488@skywalker> <49D0CEE6.2060409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59157 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZC3Opq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 10:45:46 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n2UEjSKq024853
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2009 01:45:28 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2UEjgEf274712
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2009 01:45:42 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2UEjgfR014485
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2009 01:45:42 +1100
Content-Disposition: inline
In-Reply-To: <49D0CEE6.2060409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 30, 2009 at 08:53:42AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> 
> > We do a vmtruncate if we failed to allocate blocks in
> > ext3_write_begin. That is done after the closing the current
> > transaction. If we crash in between (ie, after committing the
> > transaction allocating blocks and before committing the transaction that
> > is doing truncate) we would only have  some data blocks leaking. But
> > that would be better than user seeing zero's in the file ?. Also if we
> > happen to add the inode to the orphan list and crash, the recovery would
> > truncate it properly. So by doing a vmtruncate I guess the window would be
> > small and we are already doing that in ext3_write_begin.
> 
> I don't agree that leaking data blocks is better than exposing zeros...
> the former is a security flaw, the latter a (significant) annoyance.
> 

Even when we fail to track few data blocks we do zero them using 
page_zero_new_buffers. So it should not imply a security flaw. I guess
if we crash failing to commit the truncate fsck will look at the bitmap
and find the blocks which are not tracked by any inode and will mark them
free.

-aneesh
