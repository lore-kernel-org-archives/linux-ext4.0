From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Introduce ext4_inoblk_t
Date: Tue, 9 Oct 2007 20:48:11 -0400
Message-ID: <20071010004811.GO31713@thunk.org>
References: <1191945972-11403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42995 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXJJAsP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2007 20:48:15 -0400
Content-Disposition: inline
In-Reply-To: <1191945972-11403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 09, 2007 at 09:36:12PM +0530, Aneesh Kumar K.V wrote:
> This patch adds a new data type ext4_inoblk_t to represent
> the logical file blocks.

I'd suggest ext4_lblk_t instead of ext4_inoblk_t.  It's not at all
obvious what "inode block" means.  "Logical block" makes a lot more
sense.

Personally, I was never synced with ext4_fsblk_t myself; I think
ext4_pblk_t would make a lot more sense.

	    	       	     	  - Ted
