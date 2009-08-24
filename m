From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 17:43:36 -0600
Message-ID: <20090824234336.GU5931@webber.adilger.int>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com>
 <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int>
 <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com>
 <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com>
 <20090824232804.GJ17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62698 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbZHXXng (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 19:43:36 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7ONhW5b019769
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2009 16:43:33 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOW00F00N80UG00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 24 Aug 2009 16:43:32 -0700 (PDT)
In-reply-to: <20090824232804.GJ17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 24, 2009  19:28 -0400, Theodore Ts'o wrote:
> @@ -132,9 +132,7 @@ static int journal_submit_commit_record(journal_t *journal,
>  	set_buffer_uptodate(bh);
>  	bh->b_end_io = journal_end_buffer_io_sync;
>  
> -	if (journal->j_flags & JBD2_BARRIER &&
> -		!JBD2_HAS_INCOMPAT_FEATURE(journal,
> -					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> +	if (journal->j_flags & JBD2_BARRIER) {
>  		set_buffer_ordered(bh);
>  		barrier_done = 1;
>  	}
> 
> 
> Ok, to be fair, most of the complexity was already in the code
> already; but it the main complexity was simply separating
> journal_write_commit_record() into journal_submit_commit_record() and
> journal_wait_on_commit_record().    
> 
> We can clean up the patch by recombining these two functions, since
> there was never any point in separate submitting the commit record
> from where we waited for it.  I think who ever implemented thought we
> could add a bit more paralisms, but in reality all of the code between
> line 709 of commit.c and 834 of commit.c (i.e., commit phases 3-5) is
> waiting for the various journal data blocks to be written.  So we
> might as well wait for the commit block, which will save a bit of
> scheduling overhead, using the same rationale listed in the commit
> found in line 740 of commit.c:
> 
>       /*
>          Wait for the buffers in reverse order.  That way we are
> 	 less likely to be woken up until all IOs have completed, and
> 	 so we incur less scheduling load.
>        */

Without transaction checksums waiting on all of the blocks together
is NOT safe.  If the commit record is on disk, but the rest of the
transaction's blocks are not then during replay it may cause garbage
to be written from the journal into the filesystem metadata.

Have you seen any of my other emails on this topic?  It would seem not...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

