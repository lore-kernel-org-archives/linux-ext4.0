From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Wed, 3 Apr 2013 21:04:43 +0800
Message-ID: <20130403130443.GA16014@gmail.com>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
 <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
 <20130403123317.GD7741@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	wenqing.lz@taobao.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43265 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3DCMs2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 08:48:28 -0400
Received: by mail-pa0-f42.google.com with SMTP id kq13so886347pab.1
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 05:48:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130403123317.GD7741@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 08:33:17AM -0400, Theodore Ts'o wrote:
> On Wed, Apr 03, 2013 at 02:58:31PM +0400, Dmitry Monakhov wrote:
> > All new features are broken on bigendian hosts due to lack of conversion:
> > es_cache: https://lkml.org/lkml/2013/3/28/64
> > inode's csum and ext_to_ind_migrate are also broken.
> > 
> > Testcase: make C=2 CF="-D__CHECK_ENDIAN__
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Thanks for this comprehensive patch.  I'm currently trying to decide
> how much of this I should try to push in before the next 3.9-rcX
> window, and how much can wait until the next merge window.
> 
> We definitely want to fix the fs corruption bug for big-endian
> systems.  For the rest, I'm on the fence, since they are less likely
> to bite people hard --- metadata checksum is still pretty new and not
> fully supported, and the punch hole bug is again also pretty new
> functionality.
> 
> Also, pushing something to Linus now could potentially disrupt the
> patches in the ext4 dev tree for the next merge window.  For the zero
> extents problem, there's no question what are priorities should be;
> user dataloss trumps developer convenience any day.  For the rest,
> what do you all think?  Are they likely to hit people hard enough that
> it's worth trying to get this to Linus sooner, as opposed to having
> the fixes for the rest of the big endian issues land in 3.10 and
> 3.9.1?

Hi Ted,

I agree with you that we need to fix the big-endian bug in extent tree
because it affects all people who use ext4 file system.  Meanwhile I
think we need to fix the problem in punching hole and xattr because that
has been there.  I have looked at Dmitry's patch, and it fixes some
problems that is only in dev branch (e.g. migration).  I think this
problem can be fixed in 3.10 later.  Meanwhile metadata_csum is still
under ext4dev.  So I think it also can be fixed in next merge window.

Thanks,
                                                - Zheng
