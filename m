From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 1/3] ext4: Fix compilation with -DDX_DEBUG v2
Date: Tue, 21 Jun 2011 17:26:38 +0200
Message-ID: <4E00B82E.90209@itwm.fraunhofer.de>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain> <20110620202849.2473133.84386.stgit@localhost.localdomain> <4E0012A4.1010608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: colyli@gmail.com,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:40622 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1FUP0l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 11:26:41 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p5LFQdIi021242
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 17:26:39 +0200
In-Reply-To: <4E0012A4.1010608@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/21/2011 05:40 AM, Coly Li wrote:
>
>
> On 2011=E5=B9=B406=E6=9C=8821=E6=97=A5 04:28, Bernd Schubert Wrote:
>> changes from v1 ->  v2:
>> Use %p as suggested by Coly Li
>>
>> Compilation of ext4/namei.c brought up an error and warning messages
>> when compiled with -DDX_DEBUG
>>
>>
>> Signed-off-by: Bernd Schubert<bernd.schubert@itwm.fraunhofer.de>
>> ---
>>   fs/ext4/namei.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index b754b77..bfb749f 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -288,7 +288,7 @@ static struct stats dx_show_leaf(struct dx_hash_=
info *hinfo, struct ext4_dir_ent
>>   				char *name =3D de->name;
>>   				while (len--) printk("%c", *name++);
>>   				ext4fs_dirhash(de->name, de->name_len,&h);
>> -				printk(":%x.%u ", h.hash,
>> +				printk(":%x.%p ", h.hash,
>>   				       ((char *) de - base));
>>   			}
>>   			space +=3D EXT4_DIR_REC_LEN(de->name_len);
>> @@ -1013,7 +1013,7 @@ static struct buffer_head * ext4_dx_find_entry=
(struct inode *dir, const struct q
>>
>>   	*err =3D -ENOENT;
>>   errout:
>> -	dxtrace(printk(KERN_DEBUG "%s not found\n", name));
>> +	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
>>   	dx_release (frames);
>>   	return NULL;
>>   }
>>
>>
>
> It's OK for me.
>
> Reviewed-by: Coly Li<bosong.ly@taobao.com>
>

Arg, actually we have to change the printk to

				printk(":%x.%p ", h.hash,
  				       (void *) ((char *) de - base));

to avoid another warning. Seems I forgot to enable -DDX_DEBUG when I=20
tested it :(


Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
