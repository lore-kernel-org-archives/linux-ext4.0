From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Tue, 17 Jul 2012 15:19:27 +0800
Message-ID: <20120717071927.GA28058@gmail.com>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51274 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2GQHKw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jul 2012 03:10:52 -0400
Received: by yhmm54 with SMTP id m54so63406yhm.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2012 00:10:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FFEE402.7090601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 12, 2012 at 09:49:38AM -0500, Eric Sandeen wrote:
> On 7/12/12 1:48 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Currently in ext4 the length of zero-out chunk is set to 7.  But it is
> > too short so that it will cause a lot of fragmentation of extent when
> > we use fallocate to preallocate some uninitialized extents and the
> > workload frequently does some uninitialized extent conversions.  Thus,
> > now we set it to 256 (1MB chunk), and put it into super block in order
> > to adjust it dynamically in sysfs.
> 
> Does this in fact help the workload for which you wanted the non-flagged
> fallocate interface?

No, it almost doesn't provide any helps for that workload, but it quite
can reduce the fragmentation of extents in my test.  So IMO it can bring
some benifits for ext4. :-)

> 
> I'm a little wary of adding another user tunable; how will the user have
> any idea what value to use here?
> 
> At any rate, something should also go into Documentation/filesystems/ext4.txt
> to explain the new tunable.

Agree.  I will add this tunable parameter in ext4 doc if this patch can
be applied.

Regards,
Zheng
