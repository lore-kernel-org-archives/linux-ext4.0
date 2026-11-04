Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.171.160.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814472;
	b=th/nu1oMyTc3i1GO8zTtG5qRUTrjVbJmXupekghEFGJBEp+IxaLvr0B/3vIXn5BDIfG6
	 7lqjgmbVfioZXz72lhEVlJvZ4alGX/vkvTMoLWRW3zUoPnWo1jAp0xVz2PIxzsi9ymu+N
	 vkqvTuN+Xe31AMmwUrqDDsncXdS38jahkMrF1XY/iKrZNqDPyW1ozJ+KmgJ6QSmKCOKkg
	 Fvuur3n76J9Gb61KAbRG9fAynJv/gPKqQfCriUT03cO4jufEZWx98XqfDEgvIv9jq8CKa
	 ZEvNf4P7q8HO74FBUSlSwckXvY0Wntapm01c/KN31KusTjesbn7dh8Q6BEEfHLYd5vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814472;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type;
	bh=JtCL3jO2QRUdCPRcllSlusVnF+r8L0IiSaXuaLE6SIk=;
	b=GMu8Oy/iHjKIxYXbMZ87e5KEi860DgQONgblpQJc5s2M5zuzEoj9xlCLQOyr97F8Mg8w
	 nzu62JSZ9VUuWCLOBFG0v2Gk4mTkFkx6of5RGWZoX+1wiBOHkQgt8DSeCEQ06lTbvVx9E
	 9lj4EIuvRdARVJ388ToGGSaFLEIr7YGyZ5YDYU6+DUAfJRvg0DtSvNUJgngWKWSWfejoD
	 czvJyy/C6ci2fqJ3Jfq0nJFM5hyVIzLnQOxgaVMOfIsSes/CxjSFI+SUMUDLJD+DzLHtB
	 dI73qqVnbsmfrFAjzqN5glzjaAYUHZJ4yQzURVkJZKGAuqFXROjXqVdt/q8WId5Wahw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.parknet.co.jp;
	spf=pass smtp.mailfrom=parknet.co.jp;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=bRy3fU3W;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=gNZqXcje;
	arc=none smtp.remote-ip=210.171.160.6
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60C2606A326;
	Wed,  4 Nov 2026 17:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B60C2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=bRy3fU3W;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=gNZqXcje
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id CD2EE26F768B;
	Thu,  5 Nov 2026 02:47:40 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1793814461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JtCL3jO2QRUdCPRcllSlusVnF+r8L0IiSaXuaLE6SIk=;
	b=bRy3fU3WPpfoxNAX5TCTjlCiMCWP1OZoEEJ0ykYDt89ZfWwaVIajszzmCv/IQ6Ox/sQ1Oq
	HWn0nbOROstmKBJ1H+rryYpkssHlKpYtxRYsvFp2HuROvAueFt6RC0AM8Q6Tner0+o3QKO
	ORjCnOVPT9hly1ZyVIfon1r7k3+Ren9ofm/IFWwxM4P4iFeyD+DZXdd9ynOnHqoPedd4ju
	s0FElWOBk8uvzrTcF5yVuvhixqZLEH8s7M5TFYoJHrIFbjdDtl/PfHZe7+CsB+FWDTUTZe
	IBAC7d8/NU/MV/NhA2RlGjTO9T/nIhCOIt40GEzkjS2XEEgSj+4Ean3+2KP/eQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1793814461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JtCL3jO2QRUdCPRcllSlusVnF+r8L0IiSaXuaLE6SIk=;
	b=gNZqXcjeRAc2PP8/671dhVqqwalROPfHTPkJ9HY6We5ZdHm3+Qt0RKpqn8R9vbOdJFj7sz
	tDeCTjwSCXEjoaDA==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 51F83E000B0;
	Thu, 05 Nov 2026 02:47:40 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 467642200105; Thu, 05 Nov 2026 02:47:40 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,  linux-fsdevel@vger.kernel.org,
  Josef Bacik <josef@toxicpanda.com>,  Chris Mason <mason@kernel.org>,
  linux-ext4@vger.kernel.org,  Andreas Dilger <adilger.kernel@dilger.ca>,
  Baokun Li <libaokun@linux.alibaba.com>,  Ojaswin Mujoo
 <ojaswin@linux.ibm.com>,  "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
  Namjae Jeon <namjae.jeon@samsung.com>,  stable@vger.kernel.org
Subject: Re: [PATCH RFC 8/9] fat: sync the inode in fat_free_eofblocks()
In-Reply-To: <oilqmzo3vpddohxp46x3pjzf3wtoebahirtjqmt3izdw6ua5iq@ghdbk27wuf5f>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
	<20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
	<oilqmzo3vpddohxp46x3pjzf3wtoebahirtjqmt3izdw6ua5iq@ghdbk27wuf5f>
Date: Thu, 05 Nov 2026 02:47:40 +0900
Message-ID: <87v76co5dv.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

> On Thu 29-10-26 14:28:23, Christian Brauner wrote:
>> fat_evict_inode() calls fat_free_eofblocks() for a linked inode to give
>> back the clusters that were fallocated past the initialized size. For an
>> empty file that also resets the start cluster in the directory entry. It
>> truncates the clusters and writes the inode with:
>> 
>>   sync_inode_metadata(inode, inode_needs_sync(inode));
>> 
>> Unless the inode is IS_SYNC that is WB_SYNC_NONE writeback. It copies
>> the inode into the directory entry buffer, marks the buffer dirty and
>> sets I_METADATA_WRITEBACK. Then the inode goes away and with it the only
>> thing that would have told a later fsync() that the directory entry
>> still has to be written.
>> 
>> FAT doesn't have that problem. Its buffers are tracked on the FAT inode
>   ^^ exFAT??
>
>> and fat_file_fsync() writes them out on every fsync() of any file on the
>> filesystem.
>> 
>> So after the next fsync() the clusters are free on disk while the
>> directory entry of the empty file still points at them. If another file
>> reuses them and the machine crashes before the directory entry makes it
>> to disk, the two files share clusters. That's the corruption the comment
>> in fat_free_eofblocks() is about.
>
> Correct, but that does not violate anything AFAICT. fsync(2) promises data
> is reachable (which it is), not that the fs metadata is all
> consistent.
>
> For non-journaling filesystem you need fsck for such guarantee. And I know
> I'm a bit obtuse here but the change results in a synchronous buffer write
> on each eviction of inode that has preallocated blocks which will be a
> noticeable performance regression for some usecases. Probably Ogawa should
> decide whether this change is acceptable or whether we play fast and
> loose... Ogawa?

In my understand, the result of this change only affect to crash case
(FAT has no guarantee about it with non-sync mode). And this doesn't
lost data actually - lost some free blocks (maybe fsck would be
recoverable).

So my preference is no force sync.

Thanks.

>> So wait for the directory entry to reach the disk before the inode goes
>> away.
>> 
>> Reproducer. The image file shows what reached the disk. The flusher is
>> turned off so that it doesn't write the directory entry before fsck.fat
>> looks at the image:
>> 
>>   img=/tmp/fat.img
>>   truncate -s 64M $img
>>   mkfs.vfat $img > /dev/null
>>   dev=$(losetup -f --show $img)
>>   mount -t vfat $dev /mnt
>>   echo 0 > /proc/sys/vm/dirty_writeback_centisecs
>>   xfs_io -f -c 'falloc -k 0 1m' -c fsync /mnt/a
>>   echo 3 > /proc/sys/vm/drop_caches
>>   echo 3 > /proc/sys/vm/drop_caches
>>   xfs_io -c fsync /mnt/a
>>   fsck.fat -n $img | grep -A1 '^/a'
>>   umount /mnt
>>   losetup -d $dev
>> 
>> On v7.3-17318-g65ba8f34ec88 in a KASAN and lockdep vng guest this
>> prints:
>> 
>>   /a
>>     Contains a free cluster (3). Assuming EOF.
>> 
>> With this patch fsck.fat finds nothing wrong with /a.
>> 
>> The stable tag is narrower than the Fixes tag. Before v7.3
>> fat_free_eofblocks() called __fat_write_inode() directly and the fix
>> there is to pass 1 for wait.
>> 
>> Fixes: b13bb33eacb7 ("fat: add fat_fallocate operation")
>> Cc: stable@vger.kernel.org # v7.3
>> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
>> ---
>>  fs/fat/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index d85c8fbdcca4..fc571ee2b174 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -675,7 +675,7 @@ static void fat_free_eofblocks(struct inode *inode)
>>  		 * any corruption on the next access to the cluster
>>  		 * chain for the file.
>>  		 */
>> -		err = sync_inode_metadata(inode, inode_needs_sync(inode));
>> +		err = sync_inode_metadata(inode, 1);
>>  		if (err) {
>>  			fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
>>  					"update on disk inode for unused "
>> 
>> -- 
>> 2.53.0
>> 

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
