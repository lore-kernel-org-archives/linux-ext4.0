From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Mon, 11 May 2009 23:17:56 -0400
Message-ID: <20090512031756.GK21518@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60137 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZELDR6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 23:17:58 -0400
Content-Disposition: inline
In-Reply-To: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2009 at 04:09:28PM +0530, Aneesh Kumar K.V wrote:
> These buffer_heads are allocated on stack and are
> used only to make get_blocks calls. So we can set the
> b_state to 0
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I've rewritten the commit description to this:

ext4: Properly initialize the buffer_head state

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

These struct buffer_heads are allocated on the stack (and hence are
initialized with stack garbage).  They are only used to call a
get_blocks() function, so that's mostly OK, but b_state must be
initialized to be 0.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Comments?

					- Ted
