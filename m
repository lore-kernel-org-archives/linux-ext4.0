From: Coly Li <colyli@gmail.com>
Subject: Re: [PATCH v2] ext4: avoid eh_entries overflow before insert extent_idx
Date: Fri, 24 Jun 2011 00:51:55 +0800
Message-ID: <4E036F2B.80302@gmail.com>
References: <1308818837-5243-1-git-send-email-sanbai@taobao.com> <BANLkTimwAyb5AA5YfG92mXbkRBgAd5dKiQ@mail.gmail.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Robin Dong <hao.bigrat@gmail.com>, linux-ext4@vger.kernel.org,
	Robin Dong <sanbai@taobao.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34129 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759069Ab1FWQtr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 12:49:47 -0400
In-Reply-To: <BANLkTimwAyb5AA5YfG92mXbkRBgAd5dKiQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B406=E6=9C=8823=E6=97=A5 17:00, Yongqiang Yang Wrote:
> On Thu, Jun 23, 2011 at 4:47 PM, Robin Dong <hao.bigrat@gmail.com> wr=
ote:
>> If eh_entries is equal to (or greater than) eh_max, the operation of
>> inserting new extent_idx will make number of entries overflow.
>> So check eh_entries before inserting the new extent_idx.
>>
>> Signed-off-by: Robin Dong <sanbai@taobao.com>
>> ---
>> =EF=BF=BDfs/ext4/extents.c | =EF=BF=BD 18 ++++++++++--------
>> =EF=BF=BD1 files changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index eb63c7b..792e77e 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
[snip]

>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (unlikely(ix > EXT_LAST_IN=
DEX(curp->p_hdr))) {
> condition ix > EXT_LAST_INDEX(curp->p_hdr) can not be true.  Right?
> May be we can remove this if-statement in this patch.
>=20
> Yongqiang.
[snip]

Good suggestion. But I suggest us to remove it a little bit later. When=
 we do meta data checksum, the last index/extent
record might be used for checksum, the above checking might still be he=
lpful for bug probing.

Thanks.

Coly
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
