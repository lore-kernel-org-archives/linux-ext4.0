From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v7] ext4: fix 1k block bugs
Date: Tue, 06 Sep 2011 09:38:27 -0700
Message-ID: <4E664C83.2080001@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com> <20110906045942.GA4059@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46992 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1IFQic (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 12:38:32 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p86FIFbl007681
	for <linux-ext4@vger.kernel.org>; Tue, 6 Sep 2011 11:18:15 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p86GcTtT183628
	for <linux-ext4@vger.kernel.org>; Tue, 6 Sep 2011 12:38:30 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p86GcTGb018835
	for <linux-ext4@vger.kernel.org>; Tue, 6 Sep 2011 12:38:29 -0400
In-Reply-To: <20110906045942.GA4059@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/05/2011 09:59 PM, Ted Ts'o wrote:
> Allison,
>
> Many, many thanks for your work on this patch series!!  It's clearly
> been a very long slog.
>
> I've pulled in the first three patches, since I think those are
> clearly correct at this point.  One minor change I've made was I fixed
> the spelling the flag, which I channged to
> EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED.  (Sorry, but seeing MAPED
> everywhere was just grating on my nerves.  :-)
>
> I didn't want to apply your 4th patch in the series since we're
> planning on reducing the usage of i_mutex in the fs/ext4 code proper,
> as recommended by Christoph.  It wasn't immediately obvious to me
> whether it was safe to apply any of the patches after #4, so for now
> I've just merged in the first three, since they clearly fix real
> problems that show up in xfstests.
>
> Can you comment on whether patches #5, #6, and #7 depend on #4?
>
> Thanks,
>
> 						- Ted

Hi Ted,

Patches 5 and 6 do not depend on 4, and this set only has 6 patches, so 
no need to worry about patch 7 :)  So it is ok to just skip patch 4, I 
will see if I can find another way to solve the race conditions 
Yongqiang pointed out with out the use of i_mutex.  Many thanks to you 
too for all the help along the way. :)

Allison Henderson

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

