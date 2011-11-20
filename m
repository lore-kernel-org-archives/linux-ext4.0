From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] dumpe2fs: dump blocks count used by super and GDT
Date: Sun, 20 Nov 2011 15:08:23 +0800
Message-ID: <CAGBYx2Yca4EPk6ZZ8Q0jqbCxK9bURYcht9FKo9gcSWLmvVAMhQ@mail.gmail.com>
References: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
	<20111120044310.GJ4130@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39726 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1KTHIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Nov 2011 02:08:24 -0500
Received: by ywt32 with SMTP id 32so3749218ywt.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 23:08:23 -0800 (PST)
In-Reply-To: <20111120044310.GJ4130@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 20, 2011 at 12:43 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Nov 16, 2011 at 09:02:07AM +0800, Yongqiang Yang wrote:
>> Blocks count used by super and GDT is dumped so that users
>> can know how many blocks are taken up by super and GDT.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> I'm not convinced this is sufficiently useful to be worth adding to
> dumpe2fs. =A0How many users really need to know this?
Some users are confused by static metadata blocks allocated by extN
file systems.   Blocks used as inode tables and bitmaps can be
calculated by data from dumpe2fs.  However, blocks taken up by super
blocks and GDT can not be calculated.   So this patch prints the
number of blocks used by super blocks and GDT.   IMHO, it is useful
for some users who know little about extN.   I met several users who
ask why a fresh ext4 has used so many blocks compared to others.    I
know most of them are used as inode tables.   Without this patch, we
can explain the problem.   I just think we can explain the problem
with explicit numbers with the patch.


Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0- Ted
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
