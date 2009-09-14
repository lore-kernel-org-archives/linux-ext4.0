From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4+quota+nfs issue
Date: Tue, 15 Sep 2009 00:22:28 +0530
Message-ID: <20090914185228.GA5984@skywalker.linux.vnet.ibm.com>
References: <4AA5E5F3.30309@primeinteractive.net>
 <4AA72C14.1020005@primeinteractive.net>
 <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz>
 <4AA7C38E.8020306@redhat.com>
 <150c16850909091045h1962fd67n77c265c9b99c5f44@mail.gmail.com>
 <4AA7FBD7.9080406@primeinteractive.net>
 <4AAA5FCC.2010707@primeinteractive.net>
 <20090914175056.GE25549@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavol Cvengros <pavol.cvengros@primeinteractive.net>,
	Justin Maggard <jmaggard10@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:53934 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbZINSwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2009 14:52:36 -0400
Content-Disposition: inline
In-Reply-To: <20090914175056.GE25549@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2009 at 07:50:56PM +0200, Jan Kara wrote:
>   I've found some time to look into this and I can see a few problems in
> the code. Firstly, what may cause your problems:
>   vfs_dq_claim_blocks() is called in ext4_mb_mark_diskspace_used(). But
> as far as I can understand the code, ext4_mb_normalize_request() can
> increase the amount of space we really allocate and thus we try to
> allocate more blocks than we have actually reserved in quota. Aneesh, is
> that right?

ext4_mb_mark_diskspace_used use ac->ac_b_ex.fe_len which is NOT the normalized
request len. it is min(allocated_len, original_len). So i guess that code
should be safe
 

>   Secondly, ext4_da_reserve_space() seems to have a bug that it can reserve
> quota blocks multiple times if ext4_claim_free_blocks() fail and we retry
> the allocation. We should release the quota reservation before restarting.
> Actually, when we find out we cannot reserve quota space, we could force
> some delayed allocated writes to disk (thus possibly release some quota
> in case we have overestimated the amount of blocks needed). But that's
> a different issue.

That would imply the file system was full. But the dumpe2fs ouput list
large number of free blocks. But yes the code should have released the
quota reservation before trying block reservation again.


>   Thirdly, ext4_indirect_calc_metadata_amount() is wrong for sparse files.
> The worst case is 3 metadata blocks per data block if we make the file
> sufficiently sparse and there's no easy way around that...
> 

-aneesh
