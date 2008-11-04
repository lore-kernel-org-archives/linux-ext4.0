From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -v2 8/9] ext4: Fix double free of blocks
Date: Tue, 4 Nov 2008 11:46:04 -0500
Message-ID: <20081104164604.GK30291@mit.edu>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59298 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756844AbYKDQqT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 11:46:19 -0500
Content-Disposition: inline
In-Reply-To: <1225733769-23734-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 11:06:08PM +0530, Aneesh Kumar K.V wrote:
> blocks freed but not yet committed will be marked free
> in disk bitmap. We need to consider them as used when
> releasing inode prealloc space. Otherwise we would
> double free them via mb_free_blocks

Stupid question...   

Blocks that are added to an inode's preallocation list were initially
free, right?  And once they are in the inode's preallocation they are
marked in use by mballoc, so they can't be allocated for another
inode.  If a block in the preallocation list is used, it's removed
from the preallocation line.  So even if that inode is subsequented
unlinked or truncated, I'm curious how the double free situation
happens in the first place.

What am I missing?

					- Ted
