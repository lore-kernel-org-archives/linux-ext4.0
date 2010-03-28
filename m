From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH] resize: check s_log_groups_per_flex before accessing flex
 groups
Date: Sun, 28 Mar 2010 09:14:07 -0600
Message-ID: <96C33B08-CDC5-48B3-98C0-479F230E7F98@oracle.com>
References: <4BAE5D40.5050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alessandro Polverini <alex@nibbles.it>,
	Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42462 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab0C1POM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Mar 2010 11:14:12 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2SFE4lL004940
	for <linux-ext4@vger.kernel.org>; Sun, 28 Mar 2010 08:14:08 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KZZ00A00Y0TQN00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sun,
 28 Mar 2010 08:14:04 -0700 (PDT)
In-reply-to: <4BAE5D40.5050809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-27, at 13:32, Eric Sandeen wrote:
> #13549, Kernel oops while online resizing of an ext4 filesystem
>
> if groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
> and every other access to this first tests s_log_groups_per_flex;
> same thing needs to happen in resize or we'll wander off into
> a null pointer.

Does it even make sense to set INCOMPAT_FLEX_BG if we only have a  
single group per flexbg?  That is just a normal filesystem then.  That  
would be a separate bug in mke2fs.

> Reported-by: Alessandro Polverini <alex@nibbles.it>
> Test-case-by: Christoph Biedl  <bugzilla.kernel.bpeb@manchmal.in-ulm.de 
> >
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Index: linux-2.6/fs/ext4/resize.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/resize.c
> +++ linux-2.6/fs/ext4/resize.c
> @@ -930,7 +930,8 @@ int ext4_group_add(struct super_block *s
> 	percpu_counter_add(&sbi->s_freeinodes_counter,
> 			   EXT4_INODES_PER_GROUP(sb));
>
> -	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> +	    sbi->s_log_groups_per_flex) {
> 		ext4_group_t flex_group;
> 		flex_group = ext4_flex_group(sbi, input->group);
> 		atomic_add(input->free_blocks_count,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Principal Engineer, Lustre Group
Oracle Corporation Canada Inc.

