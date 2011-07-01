From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] ext4: Speed up FITRIM by recording flags in
 ext4_group_info.
Date: Fri, 1 Jul 2011 13:03:36 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1107011302460.4168@dhcp-27-109.brq.redhat.com>
References: <4E0C8B6C.8030403@tao.ma> <1309445439-3753-4-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1107011206580.4168@dhcp-27-109.brq.redhat.com> <4E0DA599.9040607@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1GALDl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jul 2011 07:03:41 -0400
In-Reply-To: <4E0DA599.9040607@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 1 Jul 2011, Tao Ma wrote:

> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> index 9ea71aa..080e9f9 100644
> >> --- a/fs/ext4/super.c
> >> +++ b/fs/ext4/super.c
> >> @@ -3086,6 +3086,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> >>  		sbi->s_sectors_written_start =
> >>  			part_stat_read(sb->s_bdev->bd_part, sectors[1]);
> >>  
> >> +	atomic_set(&sbi->s_last_trim_minblks, 0);
> >> +
> > 
> > I am not sure that this is needed since sbi is allocated with kzalloc,
> > so it should be zero already.
> yes, maybe. I can remove it if you like.

yes, please do.

Thanks!
> 
> Thanks
> Tao
