From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: latest -git: A peculiar case of a stuck process (ext3/sched-related?)
Date: Fri, 18 Jul 2008 14:00:13 +0100
Message-ID: <e9e943910807180600t1e65a9b8o7f85e2751368275d@mail.gmail.com>
References: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
	 <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com,
	"Ingo Molnar" <mingo@elte.hu>,
	"Peter Zijlstra" <a.p.zijlstra@chello.nl>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:17221 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbYGRNAP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 09:00:15 -0400
Received: by yx-out-2324.google.com with SMTP id 8so107964yxm.1
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 06:00:14 -0700 (PDT)
In-Reply-To: <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/7/18 Vegard Nossum <vegard.nossum@gmail.com>:
> And the ext3_find_entry() corresponds to this line:
>
>        for (; de < top; de = ext3_next_entry(de)) /* <--- HERE! */
>        if (ext3_match (namelen, name, de)) {
>                if (!ext3_check_dir_entry("ext3_find_entry",
>                                          dir, de, bh,
>                          (block<<EXT3_BLOCK_SIZE_BITS(sb))
>                                  +((char *)de - bh->b_data))) {
>                        brelse (bh);
>                        *err = ERR_BAD_DX_DIR;
>                        goto errout;
>                }
>                *res_dir = de;
>                dx_release (frames);
>                return bh;
>        }
>
> Is it possible that this loop can get stuck with a corrupt filesystem image?

It certainly is. This is the same problem as the first case reported
at http://bugzilla.kernel.org/show_bug.cgi?id=10882. There is a patch
in -mm for it already (2fde9f7a0faabe821b31ccd982d482c21f7c503f),
posted here: http://marc.info/?l=linux-kernel&m=121486328013470.

Hopefully that should fix the problem for you.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
