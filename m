From: Tao Ma <tm@tao.ma>
Subject: Re: [ext4:dev 37/63] fs/ext4/inline.c:268:19: error: 'empty_zero_page'
 undeclared
Date: Tue, 11 Dec 2012 13:17:49 +0800
Message-ID: <50C6C1FD.2020904@tao.ma>
References: <50c65c00.3GZ66LxGua+Gl+1Q%fengguang.wu@intel.com> <50C699A1.10502@tao.ma> <20121211051205.GA23653@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Tao Ma <boyu.mt@taobao.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:47261 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750719Ab2LKFRx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2012 00:17:53 -0500
In-Reply-To: <20121211051205.GA23653@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/11/2012 01:12 PM, Theodore Ts'o wrote:
> On Tue, Dec 11, 2012 at 10:25:37AM +0800, Tao Ma wrote:
>> uh, in sparc, we don't have empty_zero_page? I just want to create an
>> inline data file without allocating a buffer with the specified length.
>> So maybe I have to do the kzalloc thing then. :(
> 
> Yeah, sparc64 apparently doesn't have empty_zero_page.  All
> architectures have ZERO_PAGE(0), which is what the DIO code uses, but
> you can't count on it being mapped.
> 
> What we could do instead is pass in a value of "(void *) -1", and then
> in ext4_xattr_set_entry(), if i->value is -1, use memset to zero out
> the value instead of memcpy.  This will be safe for all architectures,
> since we already use casts of negative values for ERR_PTR.
> 
> In fact, we could just use "i.value = ERR_PTR(-1)" and
> "IS_ERR_VALUE(i->value)", but it would be clearer to explicitly define
> EXT4_ZERO_XATTR_VALUE to be "((void *) -1)", and use that to indicate
> that ext4_xattr_set_entry() should zero out the page in question.
yeah, that should saves us a lot in case of inline data creation and
updating. I will change it. Thanks for the good advice.

Thanks
Tao
