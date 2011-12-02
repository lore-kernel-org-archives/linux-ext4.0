From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize < pagesize
Date: Fri, 2 Dec 2011 09:15:46 +0800
Message-ID: <CAGBYx2Zubgp+ed297BebAjV_WYiiYnu_-Fjrz1EVkaemUCmzmg@mail.gmail.com>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
	<4ED7DFD0.8020503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65165 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab1LBBPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2011 20:15:47 -0500
Received: by ggnr5 with SMTP id r5so2412257ggn.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Dec 2011 17:15:46 -0800 (PST)
In-Reply-To: <4ED7DFD0.8020503@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 2, 2011 at 4:13 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 11/23/2011 02:15 AM, Yongqiang Yang wrote:
>>
>> If there is a unwritten but clean buffer in a page and there is a di=
rty
>> buffer
>> after the buffer, then mpage_submit_io does not write the dirty buff=
er
>> out.
>> As a result, da_writepages loops forever.
>>
>> This patch fixes the problem by checking dirty flag.
>>
>> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/inode.c | =A0 =A07 +++++--
>> =A01 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 755f6c7..20a1d17 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1339,8 +1339,11 @@ static int mpage_da_submit_io(struct mpage_da=
_data
>> *mpd,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0clear_buffer_unwritten(bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ski=
p page if block allocation undone */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bu=
ffer_delay(bh) ||
>> buffer_unwritten(bh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* s=
kip page if block allocation undone
>> and
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* b=
lock is dirty
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ex=
t4_bh_delay_or_unwritten(NULL, bh))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0skip_page =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D=
 bh->b_this_page;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block=
_start +=3D bh->b_size;
>
> Hi Yongqiang,
>
> Thank you for looking into the punch hole code, I know there's been s=
ome
> recent bugs reported, so I am looking at it too. =A0I've applied your=
 patch
> and ran it through an fsx stress test, and I notice there are some fa=
ilures,
> but it appears to run longer with the patch then with out it, so it m=
ay not
> be the cause of the errors I'm seeing. I think maybe something else m=
ay have
> happened between now and the last time it made it through 24hr of fsx=
 (at
> least for me :) ), so I'm continuing to look through the recent code
On the other hand, xfstests have a lot of changes since your last
test.   I am not sure if original xfstests did not discover some
errors.
> changes. =A0I will keep folks posted on my findings. =A0Thx!
Did you test it by multi-thread tests or single thread tests?  If
multi-thread, I suggest that we hold the i_mutex in punching hole.


Yongqiang.
>
> Allison Henderson
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
