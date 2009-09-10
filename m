From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Thu, 10 Sep 2009 12:24:01 +0530
Message-ID: <20090910065401.GB8690@skywalker.linux.vnet.ibm.com>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com>
 <20090909225429.GB24951@mit.edu>
 <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
 <20090910013540.GF24951@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37301 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZIJGyA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 02:54:00 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8A6s1lU011442
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:24:01 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8A6s1P12334906
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:24:01 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8A6s1OW025959
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 16:54:01 +1000
Content-Disposition: inline
In-Reply-To: <20090910013540.GF24951@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 09:35:40PM -0400, Theodore Tso wrote:
> On Wed, Sep 09, 2009 at 05:07:28PM -0700, Curt Wohlgemuth wrote:
> > 
> > First, ext4_journal_forget() is called from ext4_forget() only when
> > we're journalling; without a journal, ext4_journal_forget() is only
> > called for various non-extent paths.  ext4_forget() could be changed,
> > of course...
> 
> Ext4_forget() calls either ext4_journal_forget() or
> ext4_journal_revoke().  So we need to fix up both functions.
> 
> 			      	      	  - Ted
> 
> commit 4afdf0958f6f7b878e6d85cb4e0c0c12a0bd74e2
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Wed Sep 9 21:32:41 2009 -0400
> 
>     ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
>     
>     When ext4 is using a journal, a metadata block which is deallocated
>     must be passed into the journal layer so it can be dropped from the
>     current transaction and/or revoked.  This is done by calling the
>     functions ext4_journal_forget() and ext4_journal_revoke(), which call
>     jbd2_journal_forget(), and jbd2_journal_revoke(), respectively.
>     
>     Since the jbd2_journal_forget() and jbd2_journal_revoke() call
>     bforget(), if ext4 is not using a journal, ext4_journal_forget() and
>     ext4_journal_revoke() must call bforget() to avoid a dirty metadata
>     block overwriting a block after it has been reallocated and reused for
>     another inode's data block.
>     

I am sure i am missing something. But where are we adding the buffer_head
to the mapping->private_list ?. For ext2 when we allocate meta data blocks
we do mark_buffer_dirty_inode which add the buffer_head to the inodes
private_list. Shouldn't we do something similar with Ext4 without journal ?

-aneesh
