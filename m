From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for speedup
Date: Fri, 3 Feb 2012 21:28:02 +0800
Message-ID: <CAGBYx2ZATt7KG0oUvYSVWkwpVdio7iAJHHVHXFFkPqFp13Xi-Q@mail.gmail.com>
References: <4F2657AD.9060901@sx.jp.nec.com>
	<97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>
	<4F28F962.2040209@sx.jp.nec.com>
	<E2F2E1D0-8937-419F-8201-B2E9F3961AD7@dilger.ca>
	<4F2B919D.1030307@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56209 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755024Ab2BCN2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Feb 2012 08:28:04 -0500
Received: by obcva7 with SMTP id va7so4236802obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 03 Feb 2012 05:28:02 -0800 (PST)
In-Reply-To: <4F2B919D.1030307@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 3, 2012 at 3:49 PM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote:
> 2012/02/03 7:36, Andreas Dilger wrote:
>>>
>>> =A0filesystem =A0 =A0 =A0 =A0time(sec) =A0call extX_mark_inode_dirt=
y(times)
>>> =A0---
>>> =A0ext3 =A0 =A0 =A0 =A0 =A0 =A0 =A0220.5 =A0 =A0 =A050,338,104
>>> =A0ext3 (patched) =A0 =A0196.3 =A0 =A0 =A025,169,658
>>> =A0ext4 (*1) =A0 =A0 =A0 =A0 190.3 =A0 =A0 =A028,465,799
>>> =A0ext4 (*2) =A0 =A0 =A0 =A0 201.5 =A0 =A0 =A027,963,473
>>> =A0ext4 (default) =A0 =A0223.3 =A0 =A0 =A014,026,118
>>>
>>> =A0*1 disable ext4-specific options (delalloc, extent, and so on)
>>> =A0*2 disable only delalloc option
>>
>> This shows that ext4 with extents+delalloc is _slower_ than ext3, wh=
ich
>> is very strange. =A0In other similar tests of write performance (see
>
>
> One more thing is that ext4+delalloc is slower than ext4+nodelalloc.
And according to the data, maybe ext4+extent is also slower than ext4+n=
oextent.

What's the size of the fs?  and what kind of the tested device?

Yongqiang.
>
>
>> http://downloads.linux.hp.com/~enw/ext4/3.2/large_file_creates.html,
>> showing multi-threaded 1GB file writes) ext4 is much faster than ext=
3.
>
>
> I guess write buffer size of my test is different from ffsb's one.
> My test calls write systemcall every time one block is allocated,
> so it is close to the stress test I think.
>
>
>> Looking at your original email, is ext4 being tested on a RHEL 5.5
>> (2.6.18) kernel, or a more recent kernel? =A0It would be more useful
>> to run this on a more modern kernel, since the ext4 code backported
>> to RHEL5 was barely supporting delalloc at all, if I remember correc=
tly.
>
>
> I tested on the recent kernel (3.3-rc1).
> I also tested on RHEL5.5, and its result showed that ext3 was much sl=
ower
> than
> the recent kernel's one.
>
> =A0filesystem =A0 =A0 =A0 =A0time(sec)
> =A0---
> =A0ext3(RHEL5.5) =A0 =A0 438.6
> =A0ext3(3.3-rc1) =A0 =A0 220.5
>
> Regards,
> Kazuya Mio
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
