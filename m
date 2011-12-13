From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock()
 wrong parameters
Date: Tue, 13 Dec 2011 01:40:47 +0100
Message-ID: <20111213004047.GH16411@redhat.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
 <1323656828-24465-3-git-send-email-aarcange@redhat.com>
 <CAGBYx2YTiHq4mkY5uh3ZawOAz1hbdzfgV2faBDEYZz-k9bySAA@mail.gmail.com>
 <20111212165517.GE16411@redhat.com>
 <4EE65F13.3030800@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1LMAlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 19:41:16 -0500
Content-Disposition: inline
In-Reply-To: <4EE65F13.3030800@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,

On Mon, Dec 12, 2011 at 01:07:47PM -0700, Allison Henderson wrote:
> Hi Andrea,
> 
> I think what Yongqiang means is that the code you are modifying is being 
> removed in the patches listed above and replaced with a different 
> solution.  The patches have not yet been merged so you will not see them 
> in a git tree yet, so you will need to apply them yourself.  If you are 
> not subscribed to the list, you can still find the patches here:
> 
> http://www.spinics.net/lists/linux-ext4/msg29109.html
> http://www.spinics.net/lists/linux-ext4/msg29110.html
> 
> http://www.spinics.net/lists/linux-ext4/msg29375.html
> http://www.spinics.net/lists/linux-ext4/msg29376.html

Thanks for the links. Applied all 4.

> We want to make sure the solution works for everyone, so please apply 
> these patches and let us know if it corrects the issues you are seeing. 
>   Thx!

With all 4 patches applied, my 1/2 patch is still needed to avoid the
hang and writes hangs all the time (but now they don't return -EINVAL
anymore).

My patch 2/2 is not needed with the above 4 patches applied so that
can be discared if you apply the above 4 patches (but I suggest you
check my patch 2/2 too because if it happens to be correct it could
mean there's the potential of 1 byte data corruption in current
upstream kernels in some circumstances, in addition to the -EINVAL
failure in write()).

Let me know if you need me to test me anything else in relation to the
copied=0 case.

Thanks,
Andrea
