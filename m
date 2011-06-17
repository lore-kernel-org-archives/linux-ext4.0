From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 2/2] ext4 directory index: read-ahead blocks
Date: Fri, 17 Jun 2011 23:35:52 +0200
Message-ID: <4DFBC8B8.9060207@fastmail.fm>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain> <20110617160100.2062012.50927.stgit@localhost.localdomain> <4DFBA07B.6090001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: colyli@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53929 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab1FQVfy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2011 17:35:54 -0400
In-Reply-To: <4DFBA07B.6090001@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/17/2011 08:44 PM, Coly Li wrote:
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
>>
>> Unfortunately, it also has a performance trade-off for the first acc=
ess to
>> a directory, although the READA flag is set already.
>> Therefore at least for now, this option is disabled by default, but =
may
>> be enabled using 'mount -o dx_read_ahead' or 'mount -odx_read_ahead=3D=
1'
>>
>> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> ---
>=20
> A question is, is there any performance number for dx dir read ahead =
?

Well, I benchmarked it all the week now. But in between bonnie++ and
ext4 there is FhGFS... What exactly do you want to know?

> My concern is, if buffer cache replacement behavior is not ideal, whi=
ch may replace a dx block by other (maybe) more hot
> blocks, dx dir readahead will introduce more I/Os. In this case, we m=
ay focus on exploring why dx block is replaced out
> of buffer cache, other than using dx readahead.

I think we have to differentiate between two different problems. Firstl=
y
we have to get all the indexes into memory at all and secondly, keep
them in memory. Given by the high number of index blocks we have, it is
not easy to differentiate between both and I had to add several printks
or systemtap prints to get an idea why accessing the filesystem was so =
slow.

>=20
>=20
> [snip]
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 6f32da4..78290f0 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -334,6 +334,35 @@ struct stats dx_show_entries(struct dx_hash_inf=
o *hinfo, struct inode *dir,
>>  #endif /* DX_DEBUG */
>> =20
>>  /*
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
>> +
>=20
>=20
> I see sync reading here (CMIIW), this is performance killer. An async=
 background reading ahead is better.

But isn't it async? See in the new function ext4_bread_ra() please.
After ll_rw_block(READA, 1, &bh) we don't wait for the buffer to be
up-to-date, but immediately return. I also though about to add it to
worker threads, but then though that only would be additional overhead
without any gain. I didn't test and benchmark it, though.

Thanks for your review!

Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
