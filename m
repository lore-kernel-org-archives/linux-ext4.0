From: "Peng tao" <bergwolf@gmail.com>
Subject: Re: Ext4 documentation
Date: Tue, 23 Dec 2008 11:11:56 +0800
Message-ID: <6149e97b0812221911l397556dau64b7f5935cf9411f@mail.gmail.com>
References: <20081222235841.7aaaef93@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Diego Calleja" <diegocg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:50963 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYLWDL6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2008 22:11:58 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2194461rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2008 19:11:57 -0800 (PST)
In-Reply-To: <20081222235841.7aaaef93@diego-desktop>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Diego

Thanks for your efforts.

About migrating from ext3 to ext4, you suggested the following:
tune2fs -O extents,uninit_bg,flex_bg,dir_index /dev/yourfilesystem

Tuning on flex_bg isn't supported yet. tune2fs doesn't really do the
magic you want. It just sets the incompatible feature bit in super
block and nothing else. An e2fsck after that won't modify the ondisk
format either. e2fsck doesn't check log_groups_per_flex right
now(might be a bug if superblock corrupts?).

So even if you turn on flex_bg, fs doesn't benefit from flex_bg feature.

On Tue, Dec 23, 2008 at 6:58 AM, Diego Calleja <diegocg@gmail.com> wrote:
> Due to the astounding lack of good end-user documentation about Ext4, I've
> taken the freedom of writing an article about it for the kernelnewbies
> 2.6.28 changelog: http://kernelnewbies.org/Ext4
>
> If you find any error or you have some suggestion, just tell me and I'll
> fix it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Cheers,

Bergwolf

................
Margaret Mead  - "Always remember that you are absolutely unique. Just
like everyone else."
