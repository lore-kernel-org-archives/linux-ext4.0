Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FED3B6378;
	Fri,  3 Jul 2026 10:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072850; cv=none; b=ZEVWPE6PYdMtmjT3xQfF4rftFsfpf5mWyCpnin9gmqxi8mUK89gmOwfPBPkOtSOrpBx2R4AiRE+F3Ix/vW/Q03lbaRFcVgaLhDaESnheieBoFvficQY+zZxSNxTKVcUHopg5uAvn6ywv6CKosMNFX012RoGitaeu7ShvCtxo0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072850; c=relaxed/simple;
	bh=8mC0Yzhzh7Fxtct0euaUXv+huQQpu5JFzaXr5mcaye8=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=Nsn6ctfSyzcqYlMsEhjC0OLcRKG9Zd0knLzQ6SfmmuiQmW36immz+xNXOSVgZjkXfTOBLegrrd6sLCGNnEeH9uEzapt8JQFscsVs3IB/RRvayf0QqhQ6cSIJEeomGpZvk7PYDUzbL5Sn/VCIGx9H4wziP881D//eb6M6mdEhBBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/MK3EEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/MK3EEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240961F000E9;
	Fri,  3 Jul 2026 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783072843;
	bh=ZoJLlCyKWczUIxWzbQLdTBFaa2R8hwwpVEg6C/ZFh18=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=j/MK3EEFzxNv3Ct4EF7wfSVq3hUGF325Y/7KOjkk2vVM9tebiMVT1DYTZ6gJLB8kt
	 Bq83GdZXzMkpZl4/lUiwFRSyqeb9Tkug28YZ/qLBCtdfWA5I0YYIWs60v/mWeDvPHm
	 R2MjV1NwGRxAg8QgVX5T5QmbxovOre8rP9DuLsumfNWjfg/Fnel0NWvcjzJgHaEBsB
	 ccNkTPnsTuAWeroKvf+AW3XyeukuEnhCkMMpprDfQs++BBA2ztERrqXgDDgTfBoJ1R
	 vSUQCAFGLhomRj/as6zh9miPi8mEfTT/8WMNDeYp1OpCGwlsemh/HpirpNNCYmTk3k
	 plJeoGL/2a4Sg==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 04/19] ext4: Allocate mapping_metadata_bhs struct on
 demand
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
 aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20260702182057.2832980-23-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
 <20260702182057.2832980-23-jack@suse.cz>
Date: Fri, 03 Jul 2026 12:00:39 +0200
Message-Id: <20260703-abtauchen-undankbar-esskultur-c0c2186eca8f@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3398; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8mC0Yzhzh7Fxtct0euaUXv+huQQpu5JFzaXr5mcaye8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5d3hO3nAsOHX7xIRNgUm917mzri1YKBT+8Oc/rTWTN
 E2qmC75dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk3Jvhf6kMU3GspsZdQ/62
 3Q8WT3k+fcO9SaybvH6e3ykaE1jG94iRYT/j+VjxTaKrWCtuRs3bJPv6iXzKTZW1KSd6UvO4+sU
 ceAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> Currently every ext4 inode gets mapping_metadata_bhs struct although it
> is only needed when running without a journal and only for inodes where
> any metadata was dirtied. Allocate mapping_metadata_bhs struct on demand
> when dirtying the first metadata buffer for the inode.
> 
> Acked-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..36edde1bd031 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1151,7 +1151,7 @@ struct ext4_inode_info {
>  	struct rw_semaphore i_data_sem;
>  	struct inode vfs_inode;
>  	struct jbd2_inode *jinode;
> -	struct mapping_metadata_bhs i_metadata_bhs;
> +	struct mapping_metadata_bhs *i_metadata_bhs;
>  
>  	/*
>  	 * File creation time. Its function is same as that of
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 9a8c225f2753..752326f3b653 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -350,6 +350,21 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
>  	return 0;
>  }
>  
> +static void ext4_inode_attach_mmb(struct inode *inode)
> +{
> +	struct mapping_metadata_bhs *mmb;
> +
> +	/*
> +	 * It's difficult to handle failure when marking buffer dirty without
> +	 * leaving filesystem corrupted
> +	 */
> +	mmb = kmalloc_obj(*mmb, GFP_NOFS | __GFP_NOFAIL);
> +	mmb_init(mmb, &inode->i_data);
> +	/* Someone swapped another mmb before us? */
> +	if (cmpxchg(&EXT4_I(inode)->i_metadata_bhs, NULL, mmb))
> +		kfree(mmb);
> +}
> +
>  int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
>  				 handle_t *handle, struct inode *inode,
>  				 struct buffer_head *bh)
> @@ -389,11 +404,14 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
>  					 err);
>  		}
>  	} else {
> -		if (inode)
> +		if (inode) {
> +			if (!EXT4_I(inode)->i_metadata_bhs)
> +				ext4_inode_attach_mmb(inode);
>  			mmb_mark_buffer_dirty(bh,
> -					      &EXT4_I(inode)->i_metadata_bhs);
> -		else
> +					      EXT4_I(inode)->i_metadata_bhs);


> +		} else {
>  			mark_buffer_dirty(bh);
> +		}
>  		if (inode && inode_needs_sync(inode)) {
>  			sync_dirty_buffer(bh);
>  			if (buffer_req(bh) && !buffer_uptodate(bh)) {
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 924726dcc85f..c104f55a0242 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -46,6 +46,7 @@
>  static int ext4_sync_parent(struct inode *inode)
>  {
>  	struct dentry *dentry, *next;
> +	struct mapping_metadata_bhs *mmb;
>  	int ret = 0;
>  
>  	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
> @@ -68,9 +69,12 @@ static int ext4_sync_parent(struct inode *inode)
>  		 * through ext4_evict_inode()) and so we are safe to flush
>  		 * metadata blocks and the inode.
>  		 */
> -		ret = mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
> -		if (ret)
> -			break;
> +		mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);

Might make sence to just provide an access for this:

static inline struct mapping_metadata_bhs *ext4_i_metadata(struct inode *inode)
{
	return READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
}

so caller's don't have to think about the READ_ONCE() and you can
provide a central comment how this relates to the cmpxchg().

-- 
Christian Brauner <brauner@kernel.org>
