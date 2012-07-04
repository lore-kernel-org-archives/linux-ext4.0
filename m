From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Wed, 4 Jul 2012 10:23:17 +0800
Message-ID: <20120704022317.GA16947@gmail.com>
References: <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
 <4FF1DEDF.90105@redhat.com>
 <20120703174147.GA14986@gmail.com>
 <4FF3328F.3090301@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34052 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab2GDCPC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 22:15:02 -0400
Received: by pbbrp8 with SMTP id rp8so10218276pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jul 2012 19:15:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FF3328F.3090301@zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zach,

Thanks for reviewing this patch.

On Tue, Jul 03, 2012 at 10:57:35AM -0700, Zach Brown wrote:
> 
> >workload frequently does a uninitialized extent conversion.  Thus, now
> >we set it to 256 (1MB chunk), and put it into super block in order to
> >adjust it dynamically in sysfs.
> 
> It's a bit of a tangent, but this caught my eye.

Oh, actually now the default value is set to 1MB in this patch.  But I
think maybe other users want to change this value.  So I add an interface
in sysfs to adjust dynaimically.  Certainly it is convenient for me to do
the above tests. :-)

> 
> >+	/* If extent has less than 2*s_extent_zeroout_len zerout directly */
> >+	if (ee_len<= 2*sbi->s_extent_zeroout_len&&
> >  	(EXT4_EXT_MAY_ZEROOUT&  split_flag)) {
> 
> >-		if (allocated<= EXT4_EXT_ZERO_LEN&&
> >+		if (allocated<= sbi->s_extent_zeroout_len&&
> >  		(EXT4_EXT_MAY_ZEROOUT&  split_flag)) {
> 
> >  		} else if ((map->m_lblk - ee_block + map->m_len<
> >-			   EXT4_EXT_ZERO_LEN)&&
> >+			   sbi->s_extent_zeroout_len)&&
> 
> I'd be worried about having to verify that nothing bad happened if these
> sbi s_extent_zeroout_len references could see different values if they
> raced with a sysfs update.  Can they do that?
> 
> Maybe avoid the risk all together and have an on-stack copy that's only
> referenced once at the start?

I don't think 's_extent_zeroout_len' is updated frequently by user, but
using an on-stack copy quite can avoid the risk.  I will fix it if most
of all think that this patch is useful and can be applied.

Regards,
Zheng
