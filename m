From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: EXT4 data block allocation alignment
Date: Wed, 11 Jun 2014 15:03:59 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406111456110.2310@localhost.localdomain>
References: <CAKTMprNG5GzBQ1wmPhvCWzr3OKcsj8HCQ4f-mez_bSvw5D9f4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Teng-Feng Yang <shinrairis@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaFKNED (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2014 09:04:03 -0400
In-Reply-To: <CAKTMprNG5GzBQ1wmPhvCWzr3OKcsj8HCQ4f-mez_bSvw5D9f4A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 Jun 2014, Teng-Feng Yang wrote:

> Date: Wed, 11 Jun 2014 19:44:49 +0800
> From: Teng-Feng Yang <shinrairis@gmail.com>
> To: linux-ext4@vger.kernel.org
> Subject: EXT4 data block allocation alignment
> 
> Hi, folks,
> 
> Recently I have been working on a small project which requires data
> blocks of each file to be aligned to 512KB/1MB boundary for
> performance reason. As far as I know, this can be accomplished by
> setting the stripe unit on XFS or enabling the "bigalloc" feature on
> EXT4. However, the "bigalloc" feature has not yet been stated to be
> stable in the latest release. So, this makes me wondering if I can
> achieve this block allocation alignment by setting the stride-size on
> EXT4. The document of mke2fs only says that this value may be used by
> the block allocator, so I am not quite sure what it can offer for me
> in this case.

Even though bigalloc will work like that it's just nice side effect
of that feature. But, yes it should work.

However please see mke2fs manual page. Ext4 also have options to
make allocations aligned (stride, stripe_width).

There is also "stripe" mount option, but you should not need to set
that it you set it on mkfs time.

Thanks!
-Lukas

> 
> Any help would be appreciated.
> Thanks,
> 
> Dennis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
