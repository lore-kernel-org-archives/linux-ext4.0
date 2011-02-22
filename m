From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/4] EXT4 trim bug fixes and improvement.
Date: Tue, 22 Feb 2011 14:51:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102221449170.3117@dhcp-27-109.brq.redhat.com>
References: <4D522B9B.5070707@tao.ma> <4D63B5FD.2010701@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1BVNvi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 08:51:38 -0500
In-Reply-To: <4D63B5FD.2010701@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Feb 2011, Tao Ma wrote:

> Hi Ted,
>     any comments for this patch set? Are there ready for the next merge
> window?
>     The most complicate patch [4/4] has already reviewed by Andreas.

But still, I think there is a race -- see my previous comments in the
thread where I suggested using atomic_t for s_last_trim_minblks.

Thanks!
-Lukas

> 
> Regards,
> Tao
> On 02/09/2011 01:52 PM, Tao Ma wrote:
> > Hi Ted and the list,
> >     Here are 4 patches for trim support in ext4.
> >     Patch 1/4 is a fix for the 'len' overflow. As we have decided that we
> > don't adjust start to s_first_data_block, this patch is still needed.
> >     Patch 2/4 is a speedup for trim in one group.
> >     Patch 3/4 adds trace points for the functions used in FITRIM.
> >     Patch 4/4 is a speedup for trim in the whole volume. For more details,
> > please check the commit log.
> > 
> > Regards,
> > Tao
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
