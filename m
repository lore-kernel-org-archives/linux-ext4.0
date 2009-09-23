From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 23 Sep 2009 03:34:36 -0600
Message-ID: <20090923093436.GW10562@webber.adilger.int>
References: <20090916162457.GA84213@freezingfog.local>
 <20090916190831.GH2537@webber.adilger.int>
 <20090916204225.GB84213@freezingfog.local>
 <20090916212250.GL2537@webber.adilger.int>
 <20090916231131.GC84213@freezingfog.local>
 <20090919121909.GA1077@freezingfog.local>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Will Drewry <redpig@dataspill.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64242 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZIWJej (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 05:34:39 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8N9YgPM029058
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 02:34:42 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQF006003NONQ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 23 Sep 2009 02:34:42 -0700 (PDT)
In-reply-to: <20090919121909.GA1077@freezingfog.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 19, 2009  07:19 -0500, Will Drewry wrote:
> @@ -482,6 +482,8 @@ retry:
>  
>  	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>  					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
> +	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
> +					       EXT2_FEATURE_COMPAT_LAZY_BG);
>  	adj = old_fs->group_desc_count;
>  	max_group = fs->group_desc_count - adj;
>  	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
> @@ -496,9 +498,12 @@ retry:
>  		adjblocks = 0;
>  
>  		fs->group_desc[i].bg_flags = 0;
> -		if (csum_flag)
> -			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT |
> -				EXT2_BG_INODE_ZEROED;
> +		if (csum_flag) {
> +			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT;
> +			if (!lazy_flag) {
> +				fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
> +			}
> +		}

This code could be cleaned up a bit by assigning "EXT2_BG_INODE_ZEROED" to
lazy_flag so that you don't need to check this each time:

	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
					    EXT2_FEATURE_COMPAT_LAZY_BG) ?
				EXT2_BG_INODE_ZEROED : 0;

		if (csum_flag)
			fs->group_desc[i].bg_flags |=
				EXT2_BG_INODE_UNINIT | lazy_flag;

Still waiting to head from Ted on the use of COMPAT_LAZY_BG.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

