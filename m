From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Mon, 11 May 2009 09:49:24 -0500
Message-ID: <4A083AF4.5010006@redhat.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4A02FC3A.9000806@redhat.com> <20090510235741.GA3980@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZEKOt3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 10:49:29 -0400
In-Reply-To: <20090510235741.GA3980@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, May 07, 2009 at 10:20:26AM -0500, Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>> These buffer_heads are allocated on stack and are used only to
>>> make get_blocks calls. So we can set the b_state to 0
>>> 
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>> 
>> I'd noticed this too, thanks for fixing up.
> 
> Is this just a clean-up, or does this fix a bug?  It wasn't obvious 
> the patch description.  (I'm not a big fan of Ingo's 'Impact: ' 
> header, but it is good to make sure the patch description explains
> the impact of a patch.)

Aneesh responded, but AFAICT it doesn't actually fix a bug, but letting
buffer heads float around with indeterminate state can't be good in the
long run.


> In the long run, we should really look at cleaning up the get_blocks*
>  interfaces so they don't use buffer_head when all they're really
> doing is passing back a block number.  All aside from the confusion
> it causes, it also bloats our stack usage.

Overall, the kernel in general could use something in place of these
buffer-heads-that-aren't-buffer-heads, imho.

Pretty sure we use it for more than just a block nr, but it's not really
a buffer head either, it's one of these "map_bh's" - we should probably
at least try to consistently label them as such in ext*

-Eric

> - Ted

