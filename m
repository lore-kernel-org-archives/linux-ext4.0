From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fallback to vmalloc if kmalloc can't allocate s_flex_groups
 array
Date: Fri, 24 Apr 2009 22:28:04 -0500
Message-ID: <49F28344.4010707@redhat.com>
References: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com> <1240628459-25582-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50738 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZDYD2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 23:28:05 -0400
In-Reply-To: <1240628459-25582-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> For very large filesystems, the s_flex_groups array can get quite big.
> For example, a 16TB filesystem will have 8192 flex groups by default,
> so the array is 96k, which is marginal for kmalloc().  On the other
> hand, a 160GB filesystem will have 80 flex groups, so the array will
> be 960 bytes.  So we try to allocate the array first using kmalloc(),
> and if that fails, we'll try to use vmalloc() instead.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/super.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 

...

> @@ -2849,7 +2855,10 @@ failed_mount3:
>  failed_mount2:
>  	for (i = 0; i < db_count; i++)
>  		brelse(sbi->s_group_desc[i]);
> -	kfree(sbi->s_group_desc);
> +	if (is_vmalloc_addr(sbi->s_group_desc))
> +		vfree(sbi->s_group_desc);
> +	else
> +		kfree(sbi->s_group_desc);
>  failed_mount:
>  	if (sbi->s_proc) {
>  		remove_proc_entry(sb->s_id, ext4_proc_root);

er, won't you need the same vfree/kfree treatment in ext4_put_super? :)

-Eric
