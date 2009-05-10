From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Sun, 10 May 2009 19:57:41 -0400
Message-ID: <20090510235741.GA3980@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4A02FC3A.9000806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52912 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZEKIWE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 04:22:04 -0400
Content-Disposition: inline
In-Reply-To: <4A02FC3A.9000806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2009 at 10:20:26AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > These buffer_heads are allocated on stack and are
> > used only to make get_blocks calls. So we can set the
> > b_state to 0
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> I'd noticed this too, thanks for fixing up.

Is this just a clean-up, or does this fix a bug?  It wasn't obvious
the patch description.  (I'm not a big fan of Ingo's 'Impact: '
header, but it is good to make sure the patch description explains the
impact of a patch.)

In the long run, we should really look at cleaning up the get_blocks*
interfaces so they don't use buffer_head when all they're really doing
is passing back a block number.  All aside from the confusion it
causes, it also bloats our stack usage.

						- Ted
