From: tytso@mit.edu
Subject: Re: [PATCH] ext4: group cache is added in
 ext4_mb_discard_preallocations()
Date: Tue, 6 Apr 2010 14:49:52 -0400
Message-ID: <20100406184952.GM23670@thunk.org>
References: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
 <56E2631B-9D71-4B96-9F2C-D469F6994598@sun.com>
 <h2zac8f92701004010534g3607d64fh2dcf615053e59549@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33619 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab0DFSuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Apr 2010 14:50:05 -0400
Content-Disposition: inline
In-Reply-To: <h2zac8f92701004010534g3607d64fh2dcf615053e59549@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 01, 2010 at 08:34:41PM +0800, jing zhang wrote:
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc-14.c	2010-04-01 20:35:58.000000000 +0800
> @@ -4299,7 +4299,7 @@ repeat:
>  		}
>  	} else {
>  		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
> -		if (freed)
> +		if (freed && freed >= ac->ac_o_ex.fe_len)
>  			goto repeat;
>  		*errp = -ENOSPC;
>  		ac->ac_b_ex.fe_len = 0;

This is just wrong.   

Since you didn't give a justification, I'm not sure why you think it
is correct.

						- Ted
