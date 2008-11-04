From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -v2 3/9] ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT
	during resize
Date: Tue, 4 Nov 2008 13:00:44 -0500
Message-ID: <20081104180044.GO30291@mit.edu>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49108 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753301AbYKDSAs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 13:00:48 -0500
Content-Disposition: inline
In-Reply-To: <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 11:06:03PM +0530, Aneesh Kumar K.V wrote:
> The new groups added during resize are flagged as
> need_init group. Make sure we properly initialize these
> groups. When we have block size < page size and we are adding
> new groups the page may still be marked uptodate even though
> we haven't initialized the group.

Aneesh, can you explain to me again why we can't just call
ext4_mb_free_blocks().  I thought I heard you say that the buddy
bitmaps weren't appropriately initialized for the end of the bitmap
--- but I just went through mballoc.c and I couldn't see the problem.
What am I missing?

						- Ted
