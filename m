From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/5] ext4: let ext4 journal deletion of data blocks
Date: Fri, 30 Dec 2011 22:59:48 +0800
Message-ID: <CAGBYx2YbJZog0oNvyrvcyyEZ9sDQGaHZGgJyr4DxaZnX9L5fNw@mail.gmail.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
	<1321344474-14707-2-git-send-email-xiaoqiangnk@gmail.com>
	<20111228172324.GB12370@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49472 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292Ab1L3O7t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Dec 2011 09:59:49 -0500
Received: by obcwo16 with SMTP id wo16so10212413obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 06:59:49 -0800 (PST)
In-Reply-To: <20111228172324.GB12370@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

The 2nd and 3rd patch aim to let ext4_free_blocks work with journal
mode.  Consider that journal mode of a file is changed from ordered
mode to journal mode and several data blocks are deleted, then bh
passed in is NULL and sb_find_get_block returns NULL, but we need
ext4_forget to handle the data blocks to record them in revoke table.

I am not sure status of ext4 with journal mode, according code here it
seems that ext4 with journal mode does not work.

Yongqiang.

On Thu, Dec 29, 2011 at 1:23 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 15, 2011 at 04:07:51PM +0800, Yongqiang Yang wrote:
>> This patch lets ext4 journal deletion of data blocks. Besides this,
>> a unnecessary variable is removed.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> I don't see the point of this patch; it seems to be a code
> simplification, but in fact it introduces a bug which has to get fixe=
d
> in patch 3/5 of this series.
>
> The code here is a little arcane, because if bh is non-null, then
> count must be 1. =A0This is expressed in the BUG_ON found in the
> function:
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(bh && (count > 1));
>
> The reason for this bit of complexity is to avoid needing to call
> sb_find_get_block() in those places where we have the buffer_head
> already. =A0This happens in exactly two locations: in an error cleanu=
p
> path in fs/ext4/indirect.c, and when releasing an xattr block in
> ext4_xattr_release_block().
>
> The better way of dealing with this is to drop the bh argument from
> ext4_free_blocks() completely, and explicitly call ext4_forget() on
> the bh in those two functions.
>
> This will require changing all of the call sites of
> ext4_free_blocks(), but it simplifies the function signature as well
> as simplifying the code.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
>> =A0fs/ext4/mballoc.c | =A0 =A07 ++-----
>> =A01 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index e2d8be8..2529efc 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4562,19 +4562,16 @@ void ext4_free_blocks(handle_t *handle, stru=
ct inode *inode,
>> =A0 =A0 =A0 trace_ext4_free_blocks(inode, block, count, flags);
>>
>> =A0 =A0 =A0 if (flags & EXT4_FREE_BLOCKS_FORGET) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *tbh =3D bh;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int i;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(bh && (count > 1));
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < count; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bh)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tbh =3D sb=
_find_get_block(inode->i_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D sb_=
find_get_block(inode->i_sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block + i);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!tbh))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_forget(handle, flag=
s & EXT4_FREE_BLOCKS_METADATA,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 in=
ode, tbh, block + i);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 in=
ode, bh, block + i);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> --
>> 1.7.5.1
>>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
