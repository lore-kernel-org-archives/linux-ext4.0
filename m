From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: add fsync batch tuning knobs
Date: Tue, 2 Dec 2008 20:15:35 +0530
Message-ID: <20081202144535.GA9481@skywalker>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081105231012.GJ3184@webber.adilger.int> <20081106002727.GB8168@mit.edu> <4912E6F2.6010705@redhat.com> <20081125102232.GA9882@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:33552 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbYLBOps (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 09:45:48 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB2EjjI9016333
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 20:15:45 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB2EiwmN1335314
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 20:14:59 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB2EjhxZ028835
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 20:15:44 +0530
Content-Disposition: inline
In-Reply-To: <20081125102232.GA9882@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2008 at 05:22:32AM -0500, Theodore Tso wrote:
....
...

>  	{Opt_bh, "bh"},
>  	{Opt_commit, "commit=%u"},
> +	{Opt_min_batch_time, "min_batch_time=%u"},
> +	{Opt_max_batch_time, "max_batch_time=%u"},
>  	{Opt_journal_update, "journal=update"},
>  	{Opt_journal_inum, "journal=%u"},
>  	{Opt_journal_dev, "journal_dev=%u"},
> @@ -1107,6 +1119,20 @@ static int parse_options(char *options, struct super_block *sb,
>  				option = JBD2_DEFAULT_MAX_COMMIT_AGE;
>  			sbi->s_commit_interval = HZ * option;
>  			break;
> +		case Opt_max_batch_time:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			if (option < 0)
> +				return 0;
> +			if (option == 0)
> +				option = EXT4_DEF_MAX_BATCH_TIME;
> +			sbi->s_max_batch_time = option;


We need a break here .


> +		case Opt_min_batch_time:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			if (option < 0)
> +				return 0;
> +			sbi->s_min_batch_time = option;

same here

>  		case Opt_data_journal:
>  			data_opt = EXT4_MOUNT_JOURNAL_DATA;
>  			goto datacheck;
> @@ -1955,6 +1981,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> 
>  	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
>  	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
> +	sbi->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE * HZ;
> +	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
> +	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
> 
>  	set_opt(sbi->s_mount_opt, RESERVATION);
>  	set_opt(sbi->s_mount_opt, BARRIER);
....
..
The patch also needs documentation of new mount options

-aneesh
