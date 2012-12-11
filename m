From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 37/63] fs/ext4/inline.c:268:19: error:
 'empty_zero_page' undeclared
Date: Tue, 11 Dec 2012 00:12:05 -0500
Message-ID: <20121211051205.GA23653@thunk.org>
References: <50c65c00.3GZ66LxGua+Gl+1Q%fengguang.wu@intel.com>
 <50C699A1.10502@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Tao Ma <boyu.mt@taobao.com>, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37922 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2LKFMO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 00:12:14 -0500
Content-Disposition: inline
In-Reply-To: <50C699A1.10502@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 11, 2012 at 10:25:37AM +0800, Tao Ma wrote:
> uh, in sparc, we don't have empty_zero_page? I just want to create an
> inline data file without allocating a buffer with the specified length.
> So maybe I have to do the kzalloc thing then. :(

Yeah, sparc64 apparently doesn't have empty_zero_page.  All
architectures have ZERO_PAGE(0), which is what the DIO code uses, but
you can't count on it being mapped.

What we could do instead is pass in a value of "(void *) -1", and then
in ext4_xattr_set_entry(), if i->value is -1, use memset to zero out
the value instead of memcpy.  This will be safe for all architectures,
since we already use casts of negative values for ERR_PTR.

In fact, we could just use "i.value = ERR_PTR(-1)" and
"IS_ERR_VALUE(i->value)", but it would be clearer to explicitly define
EXT4_ZERO_XATTR_VALUE to be "((void *) -1)", and use that to indicate
that ext4_xattr_set_entry() should zero out the page in question.

     			    	   	    	- Ted
