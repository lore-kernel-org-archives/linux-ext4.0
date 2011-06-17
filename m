From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 1/2] ext4: Fix compilation with -DDX_DEBUG
Date: Fri, 17 Jun 2011 23:25:51 +0200
Message-ID: <4DFBC65F.7000208@fastmail.fm>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain> <4DFB9CF8.60208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: colyli@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43335 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab1FQVZx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2011 17:25:53 -0400
In-Reply-To: <4DFB9CF8.60208@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/17/2011 08:29 PM, Coly Li wrote:
> On 2011=E5=B9=B406=E6=9C=8818=E6=97=A5 00:00, Bernd Schubert Wrote:
>> From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>>
>> Compilation of ext4/namei.c brought up an error and warning messages
>> when compiled with -DDX_DEBUG
>>
>>
>> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> ---
>>  fs/ext4/namei.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index b754b77..6f32da4 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -288,8 +288,8 @@ static struct stats dx_show_leaf(struct dx_hash_=
info *hinfo, struct ext4_dir_ent
>>  				char *name =3D de->name;
>>  				while (len--) printk("%c", *name++);
>>  				ext4fs_dirhash(de->name, de->name_len, &h);
>> -				printk(":%x.%u ", h.hash,
>> -				       ((char *) de - base));
>> +				printk(":%x.%ld ", h.hash,
>> +				       (long) ((char *) de - base));
>>  			}
>=20
> How about use %p in printk like
>> +				printk(":%x.%p ", h.hash,
>> +				       ((char *) de - base));
>=20

=46ine with me :) I will send updated patches on Monday.

Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
