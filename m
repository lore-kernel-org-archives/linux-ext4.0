From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
Date: Thu, 12 Jun 2008 14:27:07 -0500
Message-ID: <1213298827.6382.2.camel@norville.austin.ibm.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-7-git-send-email-duaneg@dghda.com>
	 <20080611113104.GC9008@skywalker>
	 <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	akpm@linux-foundation.org, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47066 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbYFLT1N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 15:27:13 -0400
In-Reply-To: <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-06-11 at 12:49 +0100, Duane Griffin wrote:
> 2008/6/11 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> >> +/* Mask out flags that are inappropriate for the given type of inode. */
> >> +static inline __le32 ext4_mask_flags(__le16 mode, __le32 flags)
> >> +{
> >> +     if (S_ISDIR(mode))
> >> +             return flags;
> >> +     else if (S_ISREG(mode))
> >> +             return flags & ~EXT4_REG_FLMASK;
> >> +     else
> >> +             return flags & ~EXT4_OTHER_FLMASK;
> >> +}
> >> +
> >
> > why are the arguments __le32 ? They should be in host order.
> >
> > static inline  __u32 ext4_mask_flags(umode_t mode, __u32 flags)
> 
> Whoops, I was matching the fields in ex4_inode, but I should have been
> looking at ext4_inode_info. Shouldn't sparse have complained about
> that?

It does, but not by default.  You need to run sparse with
-D__CHECK_ENDIAN__

I use this alias:
make_sparse is aliased to `make C=2 CF="-D__CHECK_ENDIAN__"'

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

