From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 2/2] ext4 directory index: read-ahead blocks
Date: Fri, 17 Jun 2011 13:29:31 -0600
Message-ID: <DEB07822-A3AE-4309-99CF-CAC7720D3C77@whamcloud.com>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain> <20110617160100.2062012.50927.stgit@localhost.localdomain> <4DFBA07B.6090001@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	Zhen Liang <liang@whamcloud.com>
To: colyli@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab1FQT3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 15:29:36 -0400
Received: by pzk9 with SMTP id 9so2027976pzk.19
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jun 2011 12:29:35 -0700 (PDT)
In-Reply-To: <4DFBA07B.6090001@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-17, at 12:44 PM, Coly Li wrote:
> On 2011=E5=B9=B406=E6=9C=8818=E6=97=A5 00:01, Bernd Schubert Wrote:
>> While creating files in large directories we noticed an endless numb=
er
>> of 4K reads. And those reads very much reduced file creation numbers
>> as shown by bonnie. While we would expect about 2000 creates/s, we
>> only got about 25 creates/s. Running the benchmarks for a long time
>> improved the numbers, but not above 200 creates/s.
>> It turned out those reads came from directory index block reads
>> and probably the bh cache never cached all dx blocks. Given by
>> the high number of directories we have (8192) and number of files re=
quired
>> to trigger the issue (16 million), rather probably bh cached dx bloc=
ks
>> got lost in favour of other less important blocks.
>> The patch below implements a read-ahead for *all* dx blocks of a dir=
ectory
>> if a single dx block is missing in the cache. That also helps the LR=
U
>> to cache important dx blocks.
>>=20
>> Unfortunately, it also has a performance trade-off for the first acc=
ess to
>> a directory, although the READA flag is set already.
>> Therefore at least for now, this option is disabled by default, but =
may
>> be enabled using 'mount -o dx_read_ahead' or 'mount -odx_read_ahead=3D=
1'
>>=20
>> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> ---
>=20
> A question is, is there any performance number for dx dir read ahead =
?
> My concern is, if buffer cache replacement behavior is not ideal, whi=
ch may replace a dx block by other (maybe) more hot blocks, dx dir read=
ahead will
> introduce more I/Os. In this case, we may focus on exploring why dx b=
lock is
> replaced out of buffer cache, other than using dx readahead.

There was an issue we observed in our testing, where the kernel per-CPU=
 buffer LRU was too small, and for large htree directories the buffer c=
ache was always thrashing.  Currently the kernel has:

#define BH_LRU_SIZE     8

but it should be larger (16 improved performance for us by about 10%) o=
n a
16-core system in our testing (excerpt below):
> - name find of ext4 will consume about 3 slots=20
> - creating inode will take about 3 slots
> - name insert of ext4 will consume another 3-4 slots.
> - we also have some attr_set/xattr_set, which will access the LRU as =
well.
>=20
> So some BHs will be popped out from LRU before it can be using again,=
  actually profile shows __find_get_block_slow() and __find_get_block()=
 are the top time consuming functions.  I tried to increase BH_LRU_SIZE=
 to 16, and see about 8% increasing of opencreate+close rate on my bran=
ch, so I guess we actually have about 10% improvement for opencreate(on=
ly, no close) just by increasing BH_LRU_SIZE.



> [snip]
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 6f32da4..78290f0 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -334,6 +334,35 @@ struct stats dx_show_entries(struct dx_hash_inf=
o *hinfo, struct inode *dir,
>> #endif /* DX_DEBUG */
>>=20
>> /*
>> + * Read ahead directory index blocks
>> + */
>> +static void dx_ra_blocks(struct inode *dir, struct dx_entry * entri=
es)
>> +{
>> +	int i, err =3D 0;
>> +	unsigned num_entries =3D dx_get_count(entries);
>> +
>> +	if (num_entries < 2 || num_entries > dx_get_limit(entries)) {
>> +		dxtrace(printk("dx read-ahead: invalid number of entries\n"));
>> +		return;
>> +	}
>> +
>> +	dxtrace(printk("dx read-ahead: %d entries in dir-ino %lu \n",
>> +			num_entries, dir->i_ino));
>> +
>> +	i =3D 1; /* skip first entry, it was already read in by the caller=
 */
>> +	do {
>> +		struct dx_entry *entry;
>> +		ext4_lblk_t block;
>> +
>> +		entry =3D entries + i;
>> +
>> +		block =3D dx_get_block(entry);
>> +		err =3D ext4_bread_ra(dir, dx_get_block(entry));
>> +		i++;
>> +	 } while (i < num_entries && !err);
>> +}

Two objections here - this is potentially a LOT of readahead that might=
 not
be accessed.  Why not limit the number of readahead blocks to some reas=
onable
amount (e.g. 32 or 64, maybe (BH_LRU_SIZE-1) is best to avoid thrashing=
?)
and continue to submit more readahead as it traverses the directory.

It is also possible to have ext4_map_blocks() map an array of blocks at=
 one
time, which might improve the efficiency of this code a bit (it needs t=
o hold
i_data_sem during the mapping, so doing more work at once is better).

I also observe some strange inefficiency going on in buffer lookup:

__getblk()
  ->__find_get_block()
    ->lookup_bh_lru()
    ->__find_get_block_slow()

but if that fails, __getblk() continues on to call:

  ->__getblk_slow()
    ->unlikely() error message
    ->__find_get_block()
      ->lookup_bh_lru()
      ->__find_get_block_slow()
    ->grow_buffers()

It appears there is absolutely no benefit to having the initial call to
__find_get_block() in the first place.  The "unlikely() error message" =
is
out-of-line and shouldn't impact perf, and the "slow" part of __getblk_=
slow()
is skipped if __find_get_block() finds the buffer in the first place.

I could see possibly having __getblk->lookup_bh_lru() for the CPU-local
lookup avoiding some extra function calls (it would also need touch_buf=
fer()
if it finds it via lookup_bh_lru().

> I see sync reading here (CMIIW), this is performance killer. An async=
 background reading ahead is better.
>=20
> [snip]
>=20
> Thanks.
>=20
> Coly
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






Cheers, Andreas
--
Andreas Dilger=20
Principal Engineer
Whamcloud, Inc.



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
