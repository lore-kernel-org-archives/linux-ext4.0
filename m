From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 2/3] jbd: tidy up revoke cache initialisation and destruction
Date: Mon, 12 May 2008 17:11:37 +0100
Message-ID: <e9e943910805120911r4bdfaf70xdfa5412be814904e@mail.gmail.com>
References: <1209833235-30521-1-git-send-email-duaneg@dghda.com>
	 <1209833235-30521-2-git-send-email-duaneg@dghda.com>
	 <1209833235-30521-3-git-send-email-duaneg@dghda.com>
	 <20080509174259.4582008e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:43337 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYELQL4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 12:11:56 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1334853ywe.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 09:11:38 -0700 (PDT)
In-Reply-To: <20080509174259.4582008e.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/5/10 Andrew Morton <akpm@linux-foundation.org>:
> On Sat,  3 May 2008 17:47:14 +0100
>  "Duane Griffin" <duaneg@dghda.com> wrote:
>
>  > Make revocation cache destruction safe to call if initialisation fails
>  > partially or entirely. This allows it to be used to cleanup in the case of
>  > initialisation failure, simplifying that code slightly.
>
>  This crashes the kernel early in boot.  Too early to catch via netconsole,
>  which is a bit odd.

Eeek, yes, an extremely silly bug. Sorry about that. I'll send a
revised version of the patch-set shortly, and this time I'll make sure
it is properly tested.

>  I also have a feeling that [patch 1/3] causes problems too but I've run out
>  of time to bisect it further.

Was there something in particular that worried you about it? I've gone
back and done some more testing with just that one, including testing
each of the error cases manually, and all looks fine.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
