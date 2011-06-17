From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 2/2] ext4 directory index: read-ahead blocks
Date: Sat, 18 Jun 2011 00:08:14 +0200
Message-ID: <4DFBD04E.6070108@fastmail.fm>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain> <20110617160100.2062012.50927.stgit@localhost.localdomain> <4DFBA07B.6090001@gmail.com> <DEB07822-A3AE-4309-99CF-CAC7720D3C77@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: colyli@gmail.com, ext4 development <linux-ext4@vger.kernel.org>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	Zhen Liang <liang@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60495 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab1FQWIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2011 18:08:16 -0400
In-Reply-To: <DEB07822-A3AE-4309-99CF-CAC7720D3C77@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/17/2011 09:29 PM, Andreas Dilger wrote:
> On 2011-06-17, at 12:44 PM, Coly Li wrote:
>> On 2011=E5=B9=B406=E6=9C=8818=E6=97=A5 00:01, Bernd Schubert Wrote:
>>> While creating files in large directories we noticed an endless
>>> number of 4K reads. And those reads very much reduced file
>>> creation numbers as shown by bonnie. While we would expect about
>>> 2000 creates/s, we only got about 25 creates/s. Running the
>>> benchmarks for a long time improved the numbers, but not above
>>> 200 creates/s. It turned out those reads came from directory
>>> index block reads and probably the bh cache never cached all dx
>>> blocks. Given by the high number of directories we have (8192)
>>> and number of files required to trigger the issue (16 million),
>>> rather probably bh cached dx blocks got lost in favour of other
>>> less important blocks. The patch below implements a read-ahead
>>> for *all* dx blocks of a directory if a single dx block is
>>> missing in the cache. That also helps the LRU to cache important
>>> dx blocks.
>>>=20
>>> Unfortunately, it also has a performance trade-off for the first
>>> access to a directory, although the READA flag is set already.=20
>>> Therefore at least for now, this option is disabled by default,
>>> but may be enabled using 'mount -o dx_read_ahead' or 'mount
>>> -odx_read_ahead=3D1'
>>>=20
>>> Signed-off-by: Bernd Schubert
>>> <bernd.schubert@itwm.fraunhofer.de> ---
>>=20
>> A question is, is there any performance number for dx dir read
>> ahead ? My concern is, if buffer cache replacement behavior is not
>> ideal, which may replace a dx block by other (maybe) more hot
>> blocks, dx dir readahead will introduce more I/Os. In this case, we
>> may focus on exploring why dx block is replaced out of buffer
>> cache, other than using dx readahead.
>=20
> There was an issue we observed in our testing, where the kernel
> per-CPU buffer LRU was too small, and for large htree directories the
> buffer cache was always thrashing.  Currently the kernel has:
>=20
> #define BH_LRU_SIZE     8
>=20
> but it should be larger (16 improved performance for us by about 10%)
> on a 16-core system in our testing (excerpt below):
>> - name find of ext4 will consume about 3 slots - creating inode
>> will take about 3 slots - name insert of ext4 will consume another
>> 3-4 slots. - we also have some attr_set/xattr_set, which will
>> access the LRU as well.
>>=20
>> So some BHs will be popped out from LRU before it can be using
>> again,  actually profile shows __find_get_block_slow() and
>> __find_get_block() are the top time consuming functions.  I tried
>> to increase BH_LRU_SIZE to 16, and see about 8% increasing of
>> opencreate+close rate on my branch, so I guess we actually have
>> about 10% improvement for opencreate(only, no close) just by
>> increasing BH_LRU_SIZE.

I think we need to fix bh_lru_install() first, which uses BH_LRU_SIZE t=
o
allocate memory on the stack. I already tried to play with a high numbe=
r
of BH_LRU_SIZE, but run into stack memory issues...
Shouldn't be too difficult to fix, though.

>=20
>=20
>=20
>> [snip]
>>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c index
>>> 6f32da4..78290f0 100644 --- a/fs/ext4/namei.c +++
>>> b/fs/ext4/namei.c @@ -334,6 +334,35 @@ struct stats
>>> dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,=20
>>> #endif /* DX_DEBUG */
>>>=20
>>> /* + * Read ahead directory index blocks + */ +static void
>>> dx_ra_blocks(struct inode *dir, struct dx_entry * entries) +{ +
>>> int i, err =3D 0; +	unsigned num_entries =3D dx_get_count(entries);=
=20
>>> + +	if (num_entries < 2 || num_entries > dx_get_limit(entries))
>>> { +		dxtrace(printk("dx read-ahead: invalid number of
>>> entries\n")); +		return; +	} + +	dxtrace(printk("dx read-ahead:
>>> %d entries in dir-ino %lu \n", +			num_entries, dir->i_ino)); + +
>>> i =3D 1; /* skip first entry, it was already read in by the caller
>>> */ +	do { +		struct dx_entry *entry; +		ext4_lblk_t block; + +
>>> entry =3D entries + i; + +		block =3D dx_get_block(entry); +		err =3D
>>> ext4_bread_ra(dir, dx_get_block(entry)); +		i++; +	 } while (i <
>>> num_entries && !err); +}
>=20
> Two objections here - this is potentially a LOT of readahead that
> might not be accessed.  Why not limit the number of readahead blocks
> to some reasonable amount (e.g. 32 or 64, maybe (BH_LRU_SIZE-1) is
> best to avoid thrashing?) and continue to submit more readahead as it
> traverses the directory.

Do you suggest to start with a small read-ahead and to increase the
number over the time? Where could we save the last number of
read-aheads? Using a fixed value and then always

min_block =3D current_dx_block - max_ra /2
max_block =3D current_dx_block + max_ra /2

(well something like that...)

would be rather easy to add.

>=20
> It is also possible to have ext4_map_blocks() map an array of blocks
> at one time, which might improve the efficiency of this code a bit
> (it needs to hold i_data_sem during the mapping, so doing more work
> at once is better).

Hmm, that would be good of course, but will it really work? On a first
glance I see that "struct ext4_map_blocks" needs an explanation about
the member names ;)
But then I don't see an array there, but just a block number
(map->m_lblk) and the number of blocks to map (map->m_len). So doesn't
the mean the blocks need to be linearly one after the other on the disk=
?
But do have dx-blocks really that layout? From my printks it also didn'=
t
look that way. It would be good, if we could allocate large directories
from the beginning, though (should help Lustres object-hash directories
as well).
Its a bit late here and might miss something, though.

Thanks for your review!

>=20
> I also observe some strange inefficiency going on in buffer lookup:
>=20
> __getblk() ->__find_get_block() ->lookup_bh_lru()=20
> ->__find_get_block_slow()
>=20
> but if that fails, __getblk() continues on to call:
>=20
> ->__getblk_slow() ->unlikely() error message ->__find_get_block()=20
> ->lookup_bh_lru() ->__find_get_block_slow() ->grow_buffers()
>=20
> It appears there is absolutely no benefit to having the initial call
> to __find_get_block() in the first place.  The "unlikely() error
> message" is out-of-line and shouldn't impact perf, and the "slow"
> part of __getblk_slow() is skipped if __find_get_block() finds the
> buffer in the first place.
>=20
> I could see possibly having __getblk->lookup_bh_lru() for the
> CPU-local lookup avoiding some extra function calls (it would also
> need touch_buffer() if it finds it via lookup_bh_lru().

I will also look into it on Monday. Its too late for me to really follo=
w
you here.

Have a nice weekend!

Cheers,
Bernd

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
