From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 12:22:09 -0500
Message-ID: <471F7F41.6080800@redhat.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbXJXRYP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2007 13:24:15 -0400
In-Reply-To: <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:

> @@ -1279,6 +1280,9 @@ clear_qf_name:
>  		case Opt_delalloc:
>  			set_opt (sbi->s_mount_opt, DELALLOC);
>  			break;

If delalloc, mballoc, extents are the new defaults, is there a reason to
keep them as options?  When would you need to specify -o extents, now,
for example?  (though my brain is fuzzy today, maybe I'm missing
something)  If this were not a filesystem ending in "dev" I could see
keeping it for compatibility with existing fstabs....

> +		case Opt_nodelalloc:
> +			clear_opt (sbi->s_mount_opt, DELALLOC);
> +			break;
>  		case Opt_mballoc:
>  			set_opt(sbi->s_mount_opt, MBALLOC);
>  			break;
> @@ -1824,6 +1828,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
>  	 * User -o noextents to turn it off
>  	 */

I'd either update this comment ^^^^ or remove it, I think.

>  	set_opt(sbi->s_mount_opt, EXTENTS);
> +	set_opt(sbi->s_mount_opt, DELALLOC);
> +	set_opt(sbi->s_mount_opt, MBALLOC);
>  
>  	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
>  			    NULL, 0))
