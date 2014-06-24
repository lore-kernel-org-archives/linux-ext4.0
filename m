From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
Date: Tue, 24 Jun 2014 14:36:02 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406241435320.4772@localhost.localdomain>
References: <1402667736-7843-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaFXMgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2014 08:36:06 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5OCa5JA023819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 08:36:05 -0400
Received: from dhcp-1-245.brq.redhat.com (dhcp-1-245.brq.redhat.com [10.34.1.245])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5OCa3Jf003310
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 08:36:05 -0400
In-Reply-To: <1402667736-7843-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 13 Jun 2014, Lukas Czerner wrote:

> Date: Fri, 13 Jun 2014 15:55:35 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Subject: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
> 
> This is my first attempt to fix the ext4_mb_normalize_request() function in
> in ext4 which deals with file preallocations.
> 
> This is not yet a final version as it needs more testing, however I'd like
> to see some suggestions.

Does anyone have any comments on this and the related patch ?

Thanks!
-Lukas

> 
> 
> Currently there are couple of problems with ext4_mb_normalize_request().
> 
> - We're trying to normalize unwritten extents allocation which is
>   entirely unnecessary, because user exactly knows what how much space
>   he is going to need - no need for file system to do preallocations.
> 
> - ext4_mb_normalize_request() unnecessarily divides bigger allocation
>   requests to small ones (8MB). I believe that this is a bug rather than
>   design.
> 
> - For smaller allocations (or smaller files) we do not even respect the
>   fe_logical. Although we do respect it for bigger files.
> 
> - Overall the logic within ext4_mb_normalize_request() is weird and
>   no-one really understand why it is the way it is.
> 
> Fix all of this by:
> 
> - Disabling preallocation for unwritten extent allocation. However
>   because the maximum size of the unwritten extent is one block smaller
>   than written, in order to avoid unnecessary fragmentation we limit the
>   request to EXT_INIT_MAX_LEN / 2
> 
> - Get rid of the "if table" in ext4_mb_normalize_request() and replace
>   it with simply aligning the assumed end of the file up to power of
>   two. But we still limit the allocation size to EXT4_BLOCKS_PER_GROUP.
>   Also do this on file system block units to take into account different
>   block sized file systems.
> 
> 
> It passes xfstests cleanly in default configuration, I've not tried any
> non-default options yet.
> 
> I've tried to test how much it changes allocation. The test and some results
> can be found at
> 
> http://people.redhat.com/lczerner/mballoc/
> 
> normalize.sh is the simple script I run and output.normalize_orig[34]
> contains result from the vanila  3.15.0 while output.normalize_patch[56]
> contains results with this patch.
> 
> From the performance stand point I do not see any major differences except
> that untar seems to always generate better results (which might be because
> of bigger continuous extents).
> 
> Free space fragmentation seems to be about the same, however with the patch
> there seems to be less smaller free space extents and more bigger ones which
> is expected due to bigger preallocations (and I think it's a good thing).
> 
> The biggest difference which is obvious from the results is that extent tree
> is much smaller (sometimes five times smaller) with the patch. Except of the
> fallocate case because we now limit the requests to (EXT_INIT_MAX_LEN / 2)
> so we can not merge them - it might be worth experimenting with something
> smaller which is a factor of unwritten extent size.
> 
> But as I said the extent tree is much smaller which means that the extents
> overall are bigger which again is a good thing. This becomes very obvious
> when we look at the extent tree of the image file (the last steps in the
> test).
> 
> What do you think ?
> 
> Thanks!
> -Lukas
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
