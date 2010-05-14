From: Coly Li <coly.li@suse.de>
Subject: Re: [PATCH, RFC] support discard in non-journal ext4
Date: Fri, 14 May 2010 12:03:43 +0800
Message-ID: <4BECCB9F.8070007@suse.de>
References: <20100513050014.879651BC316@ruihe.smo.corp.google.com>	 <4BEBC191.7060305@suse.de> <AANLkTinniD1Acxh8CmMd1oE72fzYvmA8aEVWEWB4TS1j@mail.gmail.com>
Reply-To: coly.li@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0ENDuU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 May 2010 23:50:20 -0400
In-Reply-To: <AANLkTinniD1Acxh8CmMd1oE72fzYvmA8aEVWEWB4TS1j@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 05/14/2010 08:29 AM, Jiaying Zhang Wrote:
> On Thu, May 13, 2010 at 2:08 AM, Coly Li <coly.li@suse.de> wrote:
>>
>>
>> On 05/13/2010 01:00 PM, Jiaying Zhang Wrote:
>>> This patch issues discard request for freed blocks in ext4_free_blo=
cks()
>>> if ext4 is mounted with discard option and without journal.
>>>
>>> Author: Jiaying Zhang <jiayingz@google.com>
>>> Date: =EF=BF=BD Wed May 12 21:11:46 2010 -0700
>>>
>>> =EF=BF=BD =EF=BF=BD Issue discard request in ext4_free_blocks() whe=
n ext4 has no journal and
>>> =EF=BF=BD =EF=BF=BD is mounted with discard option.
>>>
>>> =EF=BF=BD =EF=BF=BD Signed-off-by: Jiaying Zhang <jiayingz@google.c=
om>
>>>
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index a291cc3..d51b79a 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -2513,6 +2513,22 @@ int ext4_mb_release(struct super_block *sb)
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD return 0;
>>> =EF=BF=BD}
>>>
>>> +static void ext4_issue_discard(struct super_block *sb, ext4_group_=
t block_group,
[snip]
>>
>> How about make it as an inline routine? Thanks.
>=20
> Ok. I changed it to inline. The modified patch is attached.
>=20

Acked-by: Coly Li <coly.li@suse.de>

Thanks.

--=20
Coly Li
SuSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
