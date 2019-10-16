Return-Path: <SRS0=ZSF4=YJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE08ECE58F
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Oct 2019 02:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD21820872
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Oct 2019 02:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbfJPCOf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Oct 2019 22:14:35 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55086 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729448AbfJPCOf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Oct 2019 22:14:35 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9G2ESlC012546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 22:14:30 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E7DCA420458; Tue, 15 Oct 2019 22:14:27 -0400 (EDT)
Date:   Tue, 15 Oct 2019 22:14:27 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 01/13] ext4: add handling for extended mount options
Message-ID: <20191016021427.GA31394@mit.edu>
References: <20191001074101.256523-1-harshadshirwadkar@gmail.com>
 <20191001074101.256523-2-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001074101.256523-2-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Oct 01, 2019 at 12:40:50AM -0700, Harshad Shirwadkar wrote:
> @@ -1858,8 +1863,9 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  			set_opt2(sb, EXPLICIT_DELALLOC);
>  		} else if (m->mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) {
>  			set_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM);
> -		} else
> +		} else if (m->mount_opt) {
>  			return -1;
> +		}
>  	}
>  	if (m->flags & MOPT_CLEAR_ERR)
>  		clear_opt(sb, ERRORS_MASK);

Why is this change needed?  This is in the handling of options that
have MOPT_EXPLICIT, and it doesn't seem relevant to this commit?

     		    	   	   		 - Ted
