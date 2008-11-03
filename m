From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: don't use the block freed but not yet
	committed during buddy initialization
Date: Sun, 2 Nov 2008 21:43:40 -0500
Message-ID: <20081103024340.GT8134@mit.edu>
References: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, frederic.bohe@bull.net,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36955 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754227AbYKCCnx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 21:43:53 -0500
Content-Disposition: inline
In-Reply-To: <1225471859-19718-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 31, 2008 at 10:20:59PM +0530, Aneesh Kumar K.V wrote:
> When we generate buddy cache(especially during resize) we need to make
> sure we don't use the blocks freed but not yet comitted. This make
> sure we have the right value of free blocks count in the group
> info and also in the bitmap. This also ensures the ordered mode
> consistency

Wouldn't this be fixed if we have resize call ext4_mb_free_blocks()
instead of having it regeneerate the buddy cache?

	   	     		     	   - Ted
