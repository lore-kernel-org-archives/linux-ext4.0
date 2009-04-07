From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12829] kernel complains on ENOSPC
Date: Tue, 7 Apr 2009 12:15:37 -0400
Message-ID: <20090407161537.GA29759@mit.edu>
References: <bug-12829-13602@http.bugzilla.kernel.org/> <20090310163824.6C767108042@picon.linux-foundation.org> <20090406185823.GE7376@mit.edu> <20090407143146.GA29644@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46321 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZDGQPm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 12:15:42 -0400
Content-Disposition: inline
In-Reply-To: <20090407143146.GA29644@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07, 2009 at 08:01:46PM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> No we don't need the patch. The patch is wrong. We are actually taking
> into account the allocated blocks in mballoc.c 

Ok, thanks.  I'll marked the patch as "Rejected" in the ext4 patchwork
list.  (Patchwork is really great for making sure I don't drop a
patch, and I was going through it, and I noticed this patch had been
outstanding for the last month.)

						- Ted
