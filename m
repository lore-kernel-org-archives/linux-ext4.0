From: Andrey Tsyvarev <tsyvarev@ispras.ru>
Subject: Re: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if ext4_mb_init()
 fails
Date: Tue, 13 May 2014 14:17:25 +0400
Message-ID: <5371F135.7040409@ispras.ru>
References: <1399883039-2978-1-git-send-email-tsyvarev@ispras.ru> <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


12.05.2014 19:08, Luk=C3=A1=C5=A1 Czerner =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> On Mon, 12 May 2014, Andrey Tsyvarev wrote:
>
>> Date: Mon, 12 May 2014 12:23:59 +0400
>> From: Andrey Tsyvarev<tsyvarev@ispras.ru>
>> To: Theodore Ts'o<tytso@mit.edu>
>> Cc: Andrey Tsyvarev<tsyvarev@ispras.ru>,
>>      Andreas Dilger<adilger.kernel@dilger.ca>,linux-ext4@vger.kernel=
=2Eorg,
>>      linux-kernel@vger.kernel.org, Alexey Khoroshilov<khoroshilov@is=
pras.ru>
>> Subject: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if ext4_=
mb_init()
>>      fails
>>
>> Caches from 'ext4_groupinfo_caches' may be in use by other mounts, w=
hich have already existed.
>> So, it is incorrect to destroy them when newly requested mount fails=
=2E
>>
>> Found by Linux File System Verification project (linuxtesting.org).
> Makes sense, thanks! Can you please share the test case which
> triggered this ? It might be worth including in xfstests.

Actually it was triggered by xfstests themselves but run with fault sim=
ulation.
The method of fault simulation is under development/evaluation now, we =
expect to publish a paper describing it in the near future.

BUG_ON() in get_groupinfo_cache() was firstly triggered by test generic=
/003, but actually it could be any other test, which uses a scratch dev=
ice: xftests itself requires test device(TEST_DEV) mounted, so a fault =
simulated while mount scratch device causes the problem described.


> Reviewed-by: Lukas Czerner<lczerner@redhat.com>
>
>> Signed-off-by: Andrey Tsyvarev<tsyvarev@ispras.ru>
>> ---
>>   fs/ext4/mballoc.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 04a5c75..becea1d 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -2607,7 +2607,7 @@ int ext4_mb_init(struct super_block *sb)
>>   	sbi->s_locality_groups =3D alloc_percpu(struct ext4_locality_grou=
p);
>>   	if (sbi->s_locality_groups =3D=3D NULL) {
>>   		ret =3D -ENOMEM;
>> -		goto out_free_groupinfo_slab;
>> +		goto out;
>>   	}
>>   	for_each_possible_cpu(i) {
>>   		struct ext4_locality_group *lg;
>> @@ -2632,8 +2632,6 @@ int ext4_mb_init(struct super_block *sb)
>>   out_free_locality_groups:
>>   	free_percpu(sbi->s_locality_groups);
>>   	sbi->s_locality_groups =3D NULL;
>> -out_free_groupinfo_slab:
>> -	ext4_groupinfo_destroy_slabs();
>>   out:
>>   	kfree(sbi->s_mb_offsets);
>>   	sbi->s_mb_offsets =3D NULL;
>>

--
Andrey Tsyvarev
Linux Verification Center, ISPRAS
