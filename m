From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: Reject mount an ext2 filesystem with journal
 options
Date: Mon, 20 Jul 2015 09:19:50 -0300
Message-ID: <20150720121950.GA2600@hades.maiolino.org>
References: <1435334609-23192-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbbGTMyU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2015 08:54:20 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 165A2B668F
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 12:54:20 +0000 (UTC)
Received: from hades.maiolino.org (unused [10.10.50.65] (may be forged))
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t6KCJpYX002306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA256 bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 08:19:54 -0400
Content-Disposition: inline
In-Reply-To: <1435334609-23192-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ping

On Fri, Jun 26, 2015 at 01:03:29PM -0300, Carlos Maiolino wrote:
> There is no reason to allow ext2 filesystems be mounted with journal mount
> options. So, this patch adds them to the MOPT_NO_EXT2 mount options list.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/ext4/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f06d058..e4b1141 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1366,9 +1366,9 @@ static const struct mount_opts {
>  	{Opt_stripe, 0, MOPT_GTE0},
>  	{Opt_resuid, 0, MOPT_GTE0},
>  	{Opt_resgid, 0, MOPT_GTE0},
> -	{Opt_journal_dev, 0, MOPT_GTE0},
> -	{Opt_journal_path, 0, MOPT_STRING},
> -	{Opt_journal_ioprio, 0, MOPT_GTE0},
> +	{Opt_journal_dev, 0, MOPT_NO_EXT2 | MOPT_GTE0},
> +	{Opt_journal_path, 0, MOPT_NO_EXT2 | MOPT_STRING},
> +	{Opt_journal_ioprio, 0, MOPT_NO_EXT2 | MOPT_GTE0},
>  	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
>  	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
>  	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA,
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
