Return-Path: <SRS0=G6ZV=DQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC75CC433E7
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Oct 2020 17:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9605421D6C
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Oct 2020 17:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbgJIR6m (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:58:42 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41124 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731500AbgJIR6m (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2020 13:58:42 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 099Hwb2v023944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 9 Oct 2020 13:58:37 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E9226420107; Fri,  9 Oct 2020 13:58:36 -0400 (EDT)
Date:   Fri, 9 Oct 2020 13:58:36 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v9 2/9] ext4: add fast_commit feature and handling for
 extended mount options
Message-ID: <20201009175836.GM235506@mit.edu>
References: <20200919005451.3899779-1-harshadshirwadkar@gmail.com>
 <20200919005451.3899779-3-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919005451.3899779-3-harshadshirwadkar@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Sep 18, 2020 at 05:54:44PM -0700, Harshad Shirwadkar wrote:
> We are running out of mount option bits. Add handling for using
> s_mount_opt2. Add ext4 and jbd2 fast commit feature flag and also add
> ability to turn on / off the fast commit feature in Ext4.

Shouldn't that read "...ability to turn off the fast commit feature via a
mount option"?

> @@ -2207,10 +2211,17 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  			WARN_ON(1);
>  			return -1;
>  		}
> -		if (arg != 0)
> -			sbi->s_mount_opt |= m->mount_opt;
> -		else
> -			sbi->s_mount_opt &= ~m->mount_opt;
> +		if (m->flags & MOPT_2) {
> +			if (arg != 0)
> +				sbi->s_mount_opt2 |= m->mount_opt;
> +			else
> +				sbi->s_mount_opt2 &= ~m->mount_opt;
> +		} else {
> +			if (arg != 0)
> +				sbi->s_mount_opt |= m->mount_opt;
> +			else
> +				sbi->s_mount_opt &= ~m->mount_opt;
> +		}
>  	}
>  	return 1;
>  }


This requires a matching change in _ext4_show_options(), so that the
MOPT_2 options are properly displayed in /proc/mounts.

						- Ted
