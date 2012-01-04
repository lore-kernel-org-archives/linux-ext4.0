From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH V6 RESEND 03/15] ext4: add a function which sets up a new
 group desc
Date: Wed, 4 Jan 2012 12:02:51 +0800
Message-ID: <CAGBYx2bwkJddazUT4H1D2JQC2pJx7p1MdcBZT4PdbVaN7kKk_Q@mail.gmail.com>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
	<1325242812-27005-4-git-send-email-xiaoqiangnk@gmail.com>
	<20120104022427.GF30502@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38659 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446Ab2ADECw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 23:02:52 -0500
Received: by obcwo16 with SMTP id wo16so13252430obc.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jan 2012 20:02:52 -0800 (PST)
In-Reply-To: <20120104022427.GF30502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 4, 2012 at 10:24 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 30, 2011 at 07:00:00PM +0800, Yongqiang Yang wrote:
>> +
>> + =A0 =A0 memset(gdp, 0, EXT4_DESC_SIZE(sb));
>> + =A0 =A0 =A0/* LV FIXME */
>> + =A0 =A0 memset(gdp, 0, EXT4_DESC_SIZE(sb));
>> + =A0 =A0 ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV=
 FIXME */
>> + =A0 =A0 ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV=
 FIXME */
>> + =A0 =A0 ext4_inode_table_set(sb, gdp, input->inode_table); /* LV F=
IXME */
>
> There is a duplicated (and unneeded) call to memset above. =A0Also, t=
he
> LV FIXME was a comment introduced by Laurent Vivier in commit bd81d8e=
e
> because at the time input->block_bitmap was a 32-bit value. =A0In the
> new ext4_new_group_data structure, input->block_bitmap is now a 64-bi=
t
> field, so the need for "LV FIXME" is gone, and should be removed.
>
> I'll remove the duplicate memset() calls and the "LV FIXME".
>
> For future reference, this is why it's better to use something
> descriptive about the FIXME "64-bit FIXME", as opposed to your
> initials. =A0And it's best if there's an explicit comment explaining =
why
> the fixme is there (and what the consequences of leaving partially
> broken code in the kernel :-), so that future code maintainers won't
> have to do code archeology to figure out what the FIXME is all about.
Thanks for your explanation.  I did not figure out what 'LV FIXME'
means, so I left them.   Now I am understood.

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 - Ted



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
