From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Mon, 11 May 2009 14:54:43 +0530
Message-ID: <20090511092443.GA6459@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4A02FC3A.9000806@redhat.com> <20090510235741.GA3980@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34359 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbZEKJYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 05:24:48 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4B9OjgO011426
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2009 14:54:45 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4B9Ojvd569462
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2009 14:54:45 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4B9OiEh014828
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2009 14:54:45 +0530
Content-Disposition: inline
In-Reply-To: <20090510235741.GA3980@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 10, 2009 at 07:57:41PM -0400, Theodore Tso wrote:
> On Thu, May 07, 2009 at 10:20:26AM -0500, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > These buffer_heads are allocated on stack and are
> > > used only to make get_blocks calls. So we can set the
> > > b_state to 0
> > > 
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > I'd noticed this too, thanks for fixing up.
> 
> Is this just a clean-up, or does this fix a bug?  It wasn't obvious
> the patch description.  (I'm not a big fan of Ingo's 'Impact: '
> header, but it is good to make sure the patch description explains the
> impact of a patch.)

If you are taking patch 3/3 you would need this patch. But otherwise you
can drop this. The fix is actually in patch 2/3.


-aneesh
