Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A16C3BB9EB
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790363281; cv=none; b=UC2Z5TVm2KnGuNWo5nvTe5laShac6NwHhPUlI2abROBoFt31TuqJZR5GFZEqIlgiCzonfZJjBPdZyaS+hnm2XcybIlCyHI63jwxw2MORlnd4XjQjmP3bwo59gSufF4RIsUyC9lN/jDCqKo59m/8VMazV+qUthZJyU3ZPj7mSXQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790363281; c=relaxed/simple;
	bh=i3qVX8tIPYM4M8Sajy5nrisZJ6LnTcp+cEBPgui3NMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sm1494w/rZWR9LuSXCL9vJBKzO8Y/lR+PMjiHm/13e0yfDVR96a5diZptdMAO5FJPm+ZBce7YzG5FEZpDkqrx588F6Ng8Ahh0+75Pn6YdeHLQsk4NSL6fNxhsfc5Fia4jBrekaQlma2HsGwJP1GjNfYw1da/sZ7kcDt9wOcuHBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnZQs3+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnZQs3+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BBE1F000FF;
	Fri, 25 Sep 2026 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790363273;
	bh=/kI2T9FQdLjrwVT2oVQh4iKydySDYghYc5QIfJPBLVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NnZQs3+79lniFs2J88flmV6q7K55OL+J7jfsuxmZLoVBudrKr9MIB97UH/9grAyPa
	 yAHuo95XXvFE9faWoaXxUndmdNCUBqK+20bwb0iUheAfnCKgNM7xKecpSDBkLbTISo
	 VHNC+Y2KLRtJgkh1IF/V9Vwmeg+dXaHss6LiZ7rY8iHxIsSF4Ny/PyVXjl9JK/j7Af
	 JXhWdp5hC6euEpZdxEsEHN4YyxLJA9/fRnss6sa327pT4KcBkfFZQmYjTe7So358Q0
	 z45lnL/3zbmWZv/5owZ2c9CcXYF/aYHy2UFdCARo9m6X3w2Ze3G1EDWLgEEuLmKRx4
	 Os2SnpwMSUUaA==
Date: Fri, 25 Sep 2026 12:07:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: Baokun Li <libaokun@linux.alibaba.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <20260925190751.GB2060@quark>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
 <arU-kvN-75AEmNQw@igalia.com>
 <20260924180438.GB1978@sol>
 <arZVoP0GGSNXYBLC@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arZVoP0GGSNXYBLC@igalia.com>

On Fri, Sep 25, 2026 at 01:06:08PM +0200, Alberto Garcia wrote:
> On Thu, Sep 24, 2026 at 11:04:38AM -0700, Eric Biggers wrote:
> > * And maybe a check in __ext4_iget() to prevent existing encrypted
> >   inodes from being loaded when fs_block_size > PAGE_SIZE.  This would
> >   be needed for fuzzing robustness, where a fuzzer generates a
> >   filesystem that has encrypted files without the encrypt feature flag.
> 
> Does the kernel reject encrypted files on a fs without the encrypt
> flag? I'm asking in general, regardless of the block size. Should it?

On a filesystem without the encrypt flag, ext4 rejects creating new
encrypted directories, but it doesn't reject accessing existing
encrypted directories.

It *should* reject accessing existing encrypted directories.  I think
the fact that it doesn't is a holdout from the bug that ext4 originally
had where it didn't enforce the encrypt feature flag at all.

ext4 encryption was first supported in Linux v4.1.  ext4 incorrectly
allowed creating new encrypted directories on filesystems without the
encrypt feature flag until commit 9a200d075e5 ("ext4: require encryption
feature for EXT4_IOC_SET_ENCRYPTION_POLICY") in Linux v4.9.  ext4 also
allowed the FS_IOC_GET_ENCRYPTION_POLICY ioctl on filesystems without
the encrypt feature flag until commit 0642ea2409f3bf ("ext4 crypto: fix
to check feature status before get policy") in Linux v5.4.

Since v5.4 (7 years ago), ext4 has enforced ext4_has_feature_encrypt(sb)
for all encryption ioctls.

I think at this point would be pretty safe for ext4_iget() to reject any
encrypted inodes when the filesystem doesn't have the encrypt flag.  The
only caveat is that, technically, if an existing encrypted directory is
using the old policy version (which before v5.4 was the only option), it
can be unlocked and accessed without executing any of the encryption
ioctls.  So in theory someone could be depending on that on a filesystem
without the encrypt flag.  I think it's unlikely at this point, though.

(Android for example certainly isn't depending on that, since I updated
it to use 'tune2fs -O encrypt' many years ago.  Also, its keyctl() based
unlocking code was removed and only the ioctls are used now.)

So I would suggest we just fix this as well.

- Eric
