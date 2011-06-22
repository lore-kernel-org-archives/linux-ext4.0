From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: exclude bitmap update
Date: Wed, 22 Jun 2011 11:47:49 -0600
Message-ID: <84DFE1C1-8604-4C1D-A50B-89F74FD9D143@dilger.ca>
References: <BANLkTin2Q_U1Yi+-Pe0BZ2hcxsowEM5b0g@mail.gmail.com> <BANLkTikcvkre+=cVgt_jbN5g+BxZeuEs6g@mail.gmail.com> <BANLkTi=n=mZNdoSxxNcOLQ_tztYJBR6QOg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63414 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1FVRr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 13:47:56 -0400
In-Reply-To: <BANLkTi=n=mZNdoSxxNcOLQ_tztYJBR6QOg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-22, at 6:04 AM, Amir Goldstein wrote:

> On Wed, Jun 22, 2011 at 2:17 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>> If I am right, resize in userspace will be simpler.
> 
> Yes, it will. very simple.
> The only thing you need to do in userspace is check for online resize
> support in the kernel,
> like mke2fs does for lazy_itable_init:
> 
>       if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
>               lazy_itable_init = 1;
> 
> 
> We can either just create the /sys/fs/ext4/features/online_resize entry in
> ext4_feat_attrs array with: EXT4_INFO_ATTR(online_resize);
> to indicate the new ioctl is implemented by the kernel.
> 
> Or we can export the specific features which are supported by online
> resize with:
> EXT4_RO_ATTR(online_resize);
> and an online_resize_show() function.

No, this is all much too complex, and not needed.

> Maybe somebody has a better suggestion or maybe we should just
> let the ioctl return ENOTSUP, like today, with unsupported features for resize.

Right.  This will fail for old kernels where the ioctl isn't supported, and
succeed for new kernels where it is supported, and has no added complexity.

> Then, for example, if Andreas's group will add support for online resize with
> 64bit and meta_bg features, they could use this interface to advertise the
> new resize capabilities to userspace.

There is no need for this either.  If the kernel can do the resize (regardless
of the features involved) it will succeed, and if it fails, it fails.  Passing
the new filesystem size is all that is needed.  If the user wants to enable
META_BG for resizing, this can be done via tune2fs/resize2fs from userspace
with the "s_first_meta_bg" value set to be the group after the end of the
filesystem, or possibly after the last group that would fit within the last
regular group descriptor block.

Cheers, Andreas





