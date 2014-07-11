From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: fix wrong size computation in ext4_mb_normalize_request()
Date: Fri, 11 Jul 2014 11:41:08 +0800
Message-ID: <53BF5CD4.3030804@cn.fujitsu.com>
References: <1404970836-21357-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <alpine.LFD.2.00.1407101110560.5461@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<mlombard@redhat.com>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35093 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751790AbaGKDlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 23:41:36 -0400
In-Reply-To: <alpine.LFD.2.00.1407101110560.5461@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 07/10/2014 05:25 PM, Luk=E1=9A Czerner wrote:
> On Thu, 10 Jul 2014, Xiaoguang Wang wrote:
>=20
>> Date: Thu, 10 Jul 2014 13:40:36 +0800
>> From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>> To: linux-ext4@vger.kernel.org
>> Cc: tytso@mit.edu, mlombard@redhat.com,
>>     Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>> Subject: [PATCH] ext4: fix wrong size computation in
>>     ext4_mb_normalize_request()
>>
>> As the member fe_len defined in struct ext4_free_extent is expressed=
 as
>> number of clusters, the variable "size" computation is wrong, we nee=
d to
>> first translate it to block number, then to bytes.
>>
>> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/ext4/mballoc.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 7f72f50..9a543b5 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -3076,7 +3076,8 @@ ext4_mb_normalize_request(struct ext4_allocati=
on_context *ac,
>>  		size =3D 8 * 1024 * 1024;
>>  	} else {
>>  		start_off =3D (loff_t)ac->ac_o_ex.fe_logical << bsbits;
>> -		size	  =3D ac->ac_o_ex.fe_len << bsbits;
>> +		size	  =3D EXT4_C2B(EXT4_SB(ac->ac_sb),
>> +				     ac->ac_o_ex.fe_len) << bsbits;
>=20
> There is a patch out there up for more discussion which rewrites a
> whole bunch of code in ext4_mb_normalize_request(). But more
> importantly this fix, while correct is not going to change anything
> since this condition will never be run.

Yeah, I have read your patch and related discussions, indeed this condi=
tion
would never be run, thanks for your explanation. But given that current=
ly your
patch is not merged, still this code is wrong and should be fixed.
I'm new to ext4:) Whether should I continue to send a v2 version to fix=
 this issue? thanks!

Regards,
Xiaoguang Wang
>=20
> Btw, I take back the correct part since it seems that there is a
> a possibility of overflow. This should be better.
>=20
> 		size	  =3D (loff_t)EXT4_C2B(EXT4_SB(ac->ac_sb),
> 					     ac->ac_o_ex.fe_len) << bsbits;
>=20
> Thanks!
> -Lukas
>=20
>>  	}
>>  	size =3D size >> bsbits;
>>  	start =3D start_off >> bsbits;
>>
> .
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
