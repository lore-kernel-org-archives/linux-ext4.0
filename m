From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] libblki: fix s_feature_compat usage
Date: Mon, 15 Sep 2008 16:11:02 -0700
Message-ID: <20080915231102.GE3241@webber.adilger.int>
References: <1221480209-982-1-git-send-email-kzak@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36950 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbYIOXLE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 19:11:04 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8FNB3f7022530
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 16:11:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7900M01EX0YE00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 15 Sep 2008 16:11:03 -0700 (PDT)
In-reply-to: <1221480209-982-1-git-send-email-kzak@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 15, 2008  14:03 +0200, Karel Zak wrote:
> Note that this patch also fix minor coding still errors.
> 
> @@ -150,7 +150,7 @@ static void get_ext2_info(blkid_dev dev, struct blkid_magic *id,
>  
>  	set_uuid(dev, es->s_uuid, 0);
>  
> -	if ((es->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
> +	if ((blkid_le32(es->s_feature_compat) & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&

Minor note - it is generally preferable to swab the constant value,
since this can be done at compile time instead of runtime.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

