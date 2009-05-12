From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] vfs: Add BUG_ON for delayed and unwritten extents
	in submit_bh
Date: Mon, 11 May 2009 23:17:09 -0400
Message-ID: <20090512031709.GJ21518@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60130 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbZELDRL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 23:17:11 -0400
Content-Disposition: inline
In-Reply-To: <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2009 at 04:09:30PM +0530, Aneesh Kumar K.V wrote:
> We should not do submit_bh for delayed and unwritten extents. So
> add a BUG_ON on them.

Hmm, maybe we should add a BUG_ON(buffer_new(bh)) here to?  That flag
should never leak out to submit_bh as well, right?

       	     	      	 	      	    - Ted
