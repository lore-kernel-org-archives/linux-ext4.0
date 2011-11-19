From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH] e2fsck: fix "can't find dup_blk" error
Date: Sat, 19 Nov 2011 16:32:01 +0800
Message-ID: <CAFZ0FUUQ9LA67DS2tJLd1KoQpKT-YCd4A=GCiAui2Xju4tFQXw@mail.gmail.com>
References: <1321584758-4259-1-git-send-email-hao.bigrat@gmail.com>
	<20111119040215.GE4130@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49478 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1KSIcC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 03:32:02 -0500
Received: by ggnr5 with SMTP id r5so899098ggn.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 00:32:01 -0800 (PST)
In-Reply-To: <20111119040215.GE4130@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/19 Ted Ts'o <tytso@mit.edu>:
> On Fri, Nov 18, 2011 at 10:52:38AM +0800, Robin Dong wrote:
>> From: Robin Dong <sanbai@taobao.com>
>>
>> After:
>> 1. mke2fs -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg,fl=
ex_bg,bigalloc /dev/sda
>> 2. mount -t ext4 /dev/sda /test/
>> 3. create file (8192K size, extent' e_len is 2) /test/1 ~ /test/10
>> 4. use tool to change the /test/5 extent's e_len to 100, corrupt fil=
e
>> 5. e2fsck -f /dev/sda
>
> I can't replicate this. =A0I presume it only shows up with your
> modification to the bigalloc format?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

Hi, Ted

I am not using my modification bigalloc format.
I use the upstream kernel (3.2-rc2) and uptodate e2fsprogs master
branch code, the error report will emerge after my steps above.
My /dev/sda is small (about 100G), so I guess:

# create /test/1 ~ /test/100 (e_len =3D=3D 2)
# make /test/5 's e_len to 1024

may replicate this problem on larger disk.


--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
