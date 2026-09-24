Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018C7415F1D
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790273081; cv=none; b=Sma0CG0hZ+kV94gqoSbeed84sAlad42edCb22sKDsN2ErpcGFw0KmVR2SHZN98GnBPanUAjVeR6NVHeRf0PENdAUPzJOs4ggCcQqNHgRc6T5bwYQlMgYCs7Q1LQaHsoOZnrzZ7YP6hlGaP6vjOtrDUKX3dSmDCJBnJMbVxE5LyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790273081; c=relaxed/simple;
	bh=P6S4ktHwwwjfWN4qi7ec2ABdFUg5WKEQaF1bqyOdHLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X76kQn/m9i59HkM01nWXWYAbjpXZuY0rHqIb1p5lq8tEVYULwrZcgIyYCJMLTvY8UwbGJCdi/sysrh9CqHzu7c/t2Jl3zQWxuC+TryYJP4qd6R1AeHROX1odfXs6r8qbYwJhCxE9XMZLEWBhyVEqi+qc6ie2c4DmHoTJUyADrwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+ybuzw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+ybuzw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAAF1F000FF;
	Thu, 24 Sep 2026 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790273079;
	bh=PwBRO9Z+SnrNR4OaCsRnxtsyHMtqG7pjNQ5BIp3TPp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m+ybuzw3B/4HLwArw9XlPrSIQ6pjTxyCmsdEVYc7lRc+ZrZNwUicQePq87ccxsv5C
	 9rmky8Lzch++APr4oeJ3LYIbdnJLGijXvmR8Yogw/9wsqOmXXwVaYaYIoGSR4ILfmE
	 2HHfKqYC78sPhlMa8iROaQ5SZDci7iOFJ5765c4cYMn6BLhrdZ7cAf+knHBfjxIczw
	 iRkjjOa0RpbJYWds5a5wyYclnEC2vxJM0rhQuGBkgfLplBsOc4dMJbCbLYd80LZoj9
	 5X+F4xHBotTIRGMajE2CtKkyt13jG9HFNUJPpZlDlvNuDKoV3w6VI9At8VZ4vdi665
	 oxkx6ejeqScSg==
Date: Thu, 24 Sep 2026 11:04:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: Baokun Li <libaokun@linux.alibaba.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <20260924180438.GB1978@sol>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
 <arU-kvN-75AEmNQw@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arU-kvN-75AEmNQw@igalia.com>

On Thu, Sep 24, 2026 at 05:15:30PM +0200, Alberto Garcia wrote:
> On Wed, Sep 23, 2026 at 06:01:19PM +0000, Eric Biggers wrote:
> > The proposed patch looks good
> 
> As I said, I think we need an additional check to detect if encryption
> is set on a mounted filesystem that has blocksize > pagesize.
> 
> Such a filesystem cannot be mounted (ext4_check_large_folio refuses),
> but if you do it after the fs is mounted you can crash the kernel
> using the same method.
> 
> # mkfs.ext4 -b 16384 /dev/vdb 
> # mount /dev/vdb /mnt/
> # fscrypt setup /mnt
> # tune2fs -O encrypt /dev/vdb 
> # mkdir /mnt/foo
> # fscrypt encrypt /mnt/foo/
> 
> The other patch alone does not prevent this.
> 
> With this additional change, FS_IOC_SET_ENCRYPTION_POLICY returns
> -EOPNOTSUPP, so tune2fs succeeds, but 'fscrypt encrypt' fails:
> 
>    [ERROR] fscrypt encrypt: encryption not enabled on filesystem /mnt (/dev/vdb).
> 
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -156,6 +156,9 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
>  		return -EOPNOTSUPP;
>  
> +	if (inode->i_sb->s_blocksize > PAGE_SIZE)
> +		return -EOPNOTSUPP;
> +
>  	res = ext4_convert_inline_data(inode);
>  	if (res)
>  		return res;
> 
> That prevents the crash, but the filesystem cannot be remounted:
> 
>    kernel: EXT4-fs (vdb): bs(16384) > ps(4096) unsupported for encrypt
> 
> Would this be enough or is there anything else to take into account?

Right, encryption should work with large folios now, but not with
fs_block_size > PAGE_SIZE.  For the latter, for now I think we need a
few different things to prevent it:

* (Already present) A mount-time check, to prevent mounting when the
  encrypt feature flag is set and fs_block_size > PAGE_SIZE;

* A check in ext4_set_context(), as you suggested, to prevent new
  encrypted files from being created when fs_block_size > PAGE_SIZE
  after the encrypt feature flag was set at runtime;

* tune2fs should disallow setting the encrypt feature flag in the first
  place when fs_block_size > PAGE_SIZE;

* And maybe a check in __ext4_iget() to prevent existing encrypted
  inodes from being loaded when fs_block_size > PAGE_SIZE.  This would
  be needed for fuzzing robustness, where a fuzzer generates a
  filesystem that has encrypted files without the encrypt feature flag.
  (I don't remember whether ext4 claims to support this level of fuzzing
  robustness, though.  __ext4_iget() has a few similar checks for other
  filesystem features, but it's very incomplete, so I'm not sure.)

- Eric
