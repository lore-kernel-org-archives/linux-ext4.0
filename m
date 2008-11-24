From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and
 mark_diskspace_used
Date: Mon, 24 Nov 2008 21:28:01 +0300
Message-ID: <492AF231.1070104@sun.com>
References: <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
 <20081124113323.GC8462@skywalker> <492AD821.9030506@sun.com>
 <20081124164300.GD8462@skywalker> <492AEC69.40202@sun.com>
 <20081124181252.GE8462@skywalker> <492AEFD1.4060701@sun.com>
 <20081124182132.GF8462@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:37797 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYKXS2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 13:28:15 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAOISDUd011127
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 18:28:13 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAU00301OE7L700@fe-emea-10.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Mon, 24 Nov 2008 18:28:13 +0000 (GMT)
In-reply-to: <20081124182132.GF8462@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

strange ... I'd expect the code to check "uptodate" once buffer is locked. you?

thanks, Alex

Aneesh Kumar K.V wrote:
> @@ -319,9 +319,11 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
>  			    block_group, bitmap_blk);
>  		return NULL;
>  	}
> -	if (bh_uptodate_or_lock(bh))
> +	if (buffer_uptodate(bh) &&
> +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
>  		return bh;
>  
> +	lock_buffer(bh);
>  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
>  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
>  		ext4_init_block_bitmap(sb, bh, block_group, desc);

