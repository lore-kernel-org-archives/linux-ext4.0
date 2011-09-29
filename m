From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC PATCH V2 2/6] ext4: add a delayed extents tree in inode info
Date: Thu, 29 Sep 2011 15:09:25 +0800
Message-ID: <CAGBYx2bYWs8cSp08w1_CFH+e32w0wH0EW-GMOXVEgqy58JEfng@mail.gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
	<1317272926-13303-3-git-send-email-xiaoqiangnk@gmail.com>
	<4E8416A6.3070302@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44561 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1I2HJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 03:09:26 -0400
Received: by pzk1 with SMTP id 1so890431pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2011 00:09:25 -0700 (PDT)
In-Reply-To: <4E8416A6.3070302@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 29, 2011 at 2:56 PM, Tao Ma <tm@tao.ma> wrote:
> Hi Yongqiang,
> On 09/29/2011 01:08 PM, Yongqiang Yang wrote:
>> This patch adds a delayed extents tree in inode info, so that
>> delayed extents can be look up quickly. =A0Without the tree
>> delayed extents are identified by looking up page cache.
>>
>> With the tree, FIEMAP, SEEK_HOLE/DATA, bigalloc and writeout
>> path can be optimized a lot.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/ext4.h | =A0 =A05 +++++
>> =A01 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index ccfa81f..d3c6b97 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -760,6 +760,8 @@ struct ext4_ext_cache {
>> =A0 =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 ec_len; /* must be 32bit to re=
turn holes */
>> =A0};
>>
>> +#include "delayed_extents.h"
>> +
>> =A0/*
>> =A0 * fourth extended file system inode data in memory
>> =A0 */
>> @@ -837,6 +839,9 @@ struct ext4_inode_info {
>> =A0 =A0 =A0 struct list_head i_prealloc_list;
>> =A0 =A0 =A0 spinlock_t i_prealloc_lock;
>>
>> + =A0 =A0 /* delayed extents */
>> + =A0 =A0 struct ext4_de_tree i_de_tree;
>> +
> Can we integrate this patch with patch 1/6?
> I think it would be beneficial for the reviewer to see both the
> definition of the structure and the place you put it.
Ok.  Thank you for your advice.

I will do that in next version.

Yongqiang.

>
> Thanks
> Tao
>> =A0 =A0 =A0 /* ialloc */
>> =A0 =A0 =A0 ext4_group_t =A0 =A0i_last_alloc_group;
>>
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
