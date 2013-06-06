From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: CVE request : Infinite loop in the ext4 support could cause a
 denial of service.
Date: Thu, 6 Jun 2013 10:43:21 -0400
Message-ID: <20130606144321.GB5382@thunk.org>
References: <CAEmQOhA4c_9n7xzmbpPw=aG6i-a0GLnjk510be-W58ngiZL9Gw@mail.gmail.com>
 <20130605195740.GC24020@kroah.com>
 <7056E878-6406-4BC1-BF78-0F6DD4DBBE11@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <greg@kroah.com>,
	Jonathan Salwan <jonathan.salwan@gmail.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"security@kernel.org" <security@kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55492 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab3FFOnc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jun 2013 10:43:32 -0400
Content-Disposition: inline
In-Reply-To: <7056E878-6406-4BC1-BF78-0F6DD4DBBE11@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 05, 2013 at 09:02:11PM -0600, Andreas Dilger wrote:
> 
> I think with CAP_SYS_RESOURCE there are are quite a number of
> DOS attacks possible (e.g. fork bomb). 

Ah, sorry for my earlier e-mail.  I didn't see the PoC code that was
quoted at the end of Greg's reply.

But I agree, that given that there are plenty of Denial of Service
attacks with CAP_SYS_RESOURCE, I don't believe a fix requires any
secrecy, so I'll run the patches through the normal ext4 process and
the ext4 mailing list.

If you want a CVE number for bragging points and/or for your
performance metrics (and/or to help Microsoft's propaganda machine),
feel free, but I don't consider this as a serious issue, so I don't
plan to tag the commit with a CVE number, nor to especially encourage
distro's to take this patch, unless someone sees more serious attack
vector.

> test_root() is called with "a" as the group number (any unsigned
> 32-bit number may be valid, depending on filesystem size), and "b"
> is 3, 5, and 7 in turn.  With b=3, this only takes only 21 loops (i.e. 3^21) for num to exceed 2^32. 
> 
> Ah, num is a signed int, and if "a" is 0xffffffff there is no chance
> that (a > num) is ever true due to overflow. It would be enough to
> make "num" a u64 so that it cannot overflow before it exceeds "a".

That's a reasonable fix, but then I'd suggest caching the result of
ext4_sparse_group in ext4_group_info --- which would also imply that
we would be putting in an sanity check of the group number in
ext4_bg_has_super(), or better yet in ext4_get_group_info().

We should also fix this problem another way in verify_group_input() in
fs/ext4/resize.c by sanity checking the group number in the
ext4_new_group_data structures *before* calling ext4_bg_has_super() or
ext4_group_overhead_blocks().

					- Ted
