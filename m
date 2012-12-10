From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Mon, 10 Dec 2012 11:52:39 +0530
Message-ID: <CAOiN93kaujMhfiF6m4+SrUW7jZjJE-GY_6SAba72-XAaea0rjw@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
	<CAJSVwFNbvUO_i8CY-g8xb1fWHgAmKgGHYx2hnJqW_TKVHSWtHA@mail.gmail.com>
	<CAOiN93kGE_mFGg+BLNYBLbeggnk-9nr5k0BDUTTq+81P9k3tWA@mail.gmail.com>
	<CAOiN93m+GQW3k41U6Nsnj6z7ez8nq113Wn_PFzYLzo4ahX734g@mail.gmail.com>
	<CAJSVwFNQUpVd0Kcua+VWx16RR9BsYnQyZYdVCWB6tVgcYA6LUQ@mail.gmail.com>
	<CAOiN93mbVSvANaUH3S-Y8mfa4uvYcc=iRO3vd4BUpAWgJMJdyA@mail.gmail.com>
	<CAJSVwFNPpsEPohbg_E-+brmR+ivO8Zfrd4LiNoY1nqOPkx_t+w@mail.gmail.com>
	<CAOiN93nAyBQgiOHP+YZjuoX8=61CWNoDQm9nzmgL8nabSuaxJw@mail.gmail.com>
	<CAJSVwFNFr-1908AYmMKzHirub6x+ZcSkA5v8GfSY4T1rsbO4Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Forrest Liu <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43303 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2LJGWk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2012 01:22:40 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so2119714vby.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2012 22:22:39 -0800 (PST)
In-Reply-To: <CAJSVwFNFr-1908AYmMKzHirub6x+ZcSkA5v8GfSY4T1rsbO4Ag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hi Ashish,
>
> First, create a file lager than 4GB, and then punch out every even blocks;
> Use ex command in debugfs to dump extents, belowing is the result.
>
> Level Entries           Logical              Physical Length Flags
>  0/ 3   1/  1       1 - 1048575     40013             1048575
>  1/ 3   1/  5       1 -  231160     40012             231160
>  2/ 3   1/340       1 -     680     40011                680
>  3/ 3   1/340       1 -       1   2228225 -   2228225      1
>  3/ 3   2/340       3 -       3   2228227 -   2228227      1
>  3/ 3   3/340       5 -       5   2228229 -   2228229      1
>
>
> punch out 231159, 231157, ..., 1..
>
>
> Level Entries           Logical              Physical Length Flags
>  0/ 3   1/  1       1 - 1048575     40013             1048575
>  1/ 3   1/  4  231161 -  462320   2457604             231160
>  2/ 3   1/340  231161 -  231840   2457606                680
>  3/ 3   1/340  231161 -  231161   2459385 -   2459385      1
>
>
> Then, we get incorrect logical index, if only do correction in ext4_ext_rm_leaf.

Ok, In your patch we can do without varibale border and instead use:
path->p_idx->ei_block = (path+1)->p_idx->ei_block;

Rest of the patch seems Ok.

Thanks,
Ashish
>
>
> Thanks,
> Forrest
