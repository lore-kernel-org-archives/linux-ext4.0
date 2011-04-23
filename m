From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix incorrect error-message of ext2
Date: Sat, 23 Apr 2011 09:12:14 -0500
Message-ID: <4DB2DE3E.2090704@redhat.com>
References: <1303565818-19512-1-git-send-email-hao.bigrat@gmail.com> <4DB2E0D9.7090009@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Robin Dong <sanbai@taobao.com>, linux-ext4@vger.kernel.org
To: i@coly.li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab1DWOMU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Apr 2011 10:12:20 -0400
In-Reply-To: <4DB2E0D9.7090009@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/23/11 9:23 AM, Coly Li wrote:
> On 2011=E5=B9=B404=E6=9C=8823=E6=97=A5 21:36, Robin Dong Wrote:
>> From: Robin Dong <sanbai@taobao.com>
>>
>> After "mkfs.ext2 -b 8192" on a new partition, I mount it with a erro=
r dmesg:
>> "error: blocksize is too small"
>> That's not correct.
>>
>=20
> Agree, it should be too big, or invalid block size.
>=20
>> Signed-off-by: Robin Dong <sanbai@taobao.com>
> [snip]
>> +	hblock =3D bdev_logical_block_size(sb->s_bdev);
>>  	/* If the blocksize doesn't match, re-read the thing.. */
>>  	if (sb->s_blocksize !=3D blocksize) {
>> +		/*
>> +		 * Make sure the blocksize for the filesystem is larger
>> +		 * than the hardware sectorsize for the machine.
>> +		 */
>> +		if (blocksize < hblock) {
>> +			ext2_msg(sb, KERN_ERR,
>> +				"error: fsblocksize %d too small for "
>> +				"hardware sectorsize %d", blocksize, hblock);
>=20
> When a file system is mounted, the reported underlying dev logical bl=
ock size may be larger than a sector size.

True, but set_blocksize will fail it:

        /* Size cannot be smaller than the size supported by the device=
 */
        if (size < bdev_logical_block_size(bdev))
                return -EINVAL;

Above patch is really just repeating this test.

>> +			goto failed_mount;
>> +		}
>> +
>>  		brelse(bh);
>> =20
>=20
> How about just keeping bellowed lines ? Reporting bad block size numb=
er is the behavior how Ext3 and Ext4 do.
>=20
>>  		if (!sb_set_blocksize(sb, blocksize)) {
>> -			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
>> +			ext2_msg(sb, KERN_ERR,
>> +				"error: bad blocksize %d", blocksize);
>>  			goto failed_sbi;
>>  		}

Agreed, this change makes it consistent with ext3, and I think that it =
is enough.

Thanks,
-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
