From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext3 : Remove redundant condition in ext3_free_blocks_sb()
Date: Sun, 1 Jun 2008 00:40:32 +0530
Message-ID: <ea11fea30805311210o15de2373m71d91228356f9bfd@mail.gmail.com>
References: <ea11fea30805311156q7488714ftf8b0b8b8cea85b76@mail.gmail.com>
	 <20080531190527.GG28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "Al Viro" <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:30118 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYEaTKf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 May 2008 15:10:35 -0400
Received: by ti-out-0910.google.com with SMTP id b6so129083tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 31 May 2008 12:10:32 -0700 (PDT)
In-Reply-To: <20080531190527.GG28946@ZenIV.linux.org.uk>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 1, 2008 at 12:35 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jun 01, 2008 at 12:26:41AM +0530, Manish Katiyar wrote:
>> For two unsigned values the check "block+count < block"  is always
>> false. Thus the below patch removes that condition.
>
> Really?  Always?
>
>        unsigned block = 1;
>        unsigned count = ~0U;
>
> What will be the value and type of block + count?  What will be the
> value of block + count < block?

Oooops....my bad, but I doubt if we pass such values in ext* code anywhere.

>



-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
