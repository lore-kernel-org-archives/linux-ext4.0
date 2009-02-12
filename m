From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12672] New: lockdep warning when using ext4 on x86_64
Date: Thu, 12 Feb 2009 16:42:48 -0500
Message-ID: <20090212214248.GF6922@mini-me.lan>
References: <bug-12672-13602@http.bugzilla.kernel.org/> <20090209083236.GB31884@skywalker> <20090209100817.GC31884@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41678 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbZBLXmk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 18:42:40 -0500
Content-Disposition: inline
In-Reply-To: <20090209100817.GC31884@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 09, 2009 at 03:38:17PM +0530, Aneesh Kumar K.V wrote:
> 
> Updated patch
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Subject: [PATCH] ext4: Fix lockdep warning
> 
> We should not call ext4_mb_add_n_trim while holding alloc_semp.

Added to the ext4 patch queue.

					- Ted
