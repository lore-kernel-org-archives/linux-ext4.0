From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Tue, 17 Jul 2012 15:55:26 +0800
Message-ID: <20120717075526.GA4375@gmail.com>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
 <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Zach Brown <zab@zabbo.net>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2GQHqv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jul 2012 03:46:51 -0400
Received: by pbbrp8 with SMTP id rp8so393145pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2012 00:46:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 12, 2012 at 10:51:12AM -0600, Andreas Dilger wrote:
> On 2012-07-12, at 8:49 AM, Eric Sandeen wrote:
> > On 7/12/12 1:48 AM, Zheng Liu wrote:
> >> From: Zheng Liu <wenqing.lz@taobao.com>
> >> 
> >> Currently in ext4 the length of zero-out chunk is set to 7.  But it is
> >> too short so that it will cause a lot of fragmentation of extent when
> >> we use fallocate to preallocate some uninitialized extents and the
> >> workload frequently does some uninitialized extent conversions.  Thus,
> >> now we set it to 256 (1MB chunk), and put it into super block in order
> >> to adjust it dynamically in sysfs.
> > 
> > Does this in fact help the workload for which you wanted the non-flagged
> > fallocate interface?
> > 
> > I'm a little wary of adding another user tunable; how will the user have
> > any idea what value to use here?
> 
> It would make sense to use the s_raid_stripe_width as the default value for
> this parameter.  The other thing we need to pay attention to is that the
> growth of the extent zeroing be done on a RAID or erase-block aligned manner.
> Otherwise, this might cause extra IO that doesn't benefit the application.

There is a problem that we use the s_raid_stripe_width as the default
value, which is that this value will be 0 when we simply use mkfs.ext4
without '-E stripe-width=XXX'.  when this value is 0, we still need to
choose a number as the default value.  So I think that we can choose 256
when the s_raid_stripe_width is 0.

Regards,
Zheng

> It appears that the current code does not pay attention to alignment, and
> that should be fixed before landing this patch with larger zero-out sizes.
