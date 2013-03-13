From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: [qrxd43@motorola.com: [PATCH V2] ext4: speed-up releasing blocks
 on commit]
Date: Wed, 13 Mar 2013 14:38:55 +0400
Message-ID: <CAA0+VHyOqK-yQqWZPjkwfTDzfFj_Bvy=cAtUdZXx1vOS6B7OcA@mail.gmail.com>
References: <20130203031122.GC1359@thunk.org>
	<88575CD0-1CF4-4C12-83ED-845C87FFFDA4@dilger.ca>
	<94F448E5-429B-4740-BF87-CE82F477DE93@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:40247 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3CMLVU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2013 07:21:20 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.22.94.167])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2DAfpHO028596
	for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 06:41:51 -0400 (EDT)
Received: from mail-ob0-f178.google.com (mail-ob0-f178.google.com [209.85.214.178])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2DAfoXP028589
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 06:41:51 -0400 (EDT)
Received: by mail-ob0-f178.google.com with SMTP id wd20so860933obb.9
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 03:38:55 -0700 (PDT)
In-Reply-To: <94F448E5-429B-4740-BF87-CE82F477DE93@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Alex,

Thanks for review! I'll post rebased patch with comments and some
ascii art this weekend.

> the patch looks fine, the only suggestion is to move the following logic
> into mb_buddy_mark_free():
>
> + if (first & 1) {
> + first += !left_is_free;
> + e4b->bd_info->bb_counters[0] += left_is_free ? -1 : 1;
> + }
> + if (!(last & 1)) {
> + last -= !right_is_free;
> + e4b->bd_info->bb_counters[0] += right_is_free ? -1 : 1;
> + }

I didn't do that since buddy[0] is a special case since it is in fact
bd_bitmap itself. Moving that into mb_buddy_mark_free will make code
look worse because of this special handling. I think unrolling first
iteration that handles bd_bitmap looks much better.

Regards,
Andrey.
