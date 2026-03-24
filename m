Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32832C21F6;
	Tue, 24 Mar 2026 05:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330824; cv=none; b=hit4BoEraUiBNjsF9W/iJpzxIXZE5nLpDpOyB5DdaNPIboYqia0w+jnADszCVtWKfBw5eJJN6WTGWxJxc9822NxIsIMoZ7OP5LgllzSwhFSNwjekFwyYMe7jJTFmahWlNOnB35heoLngWGxB/7RUXQslGd5CVuqNLdAj+P85nxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330824; c=relaxed/simple;
	bh=O9P/EB0s1MTzvdiDovcbN5bmbF8IWPrqNyiAQw9t1X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=maW4IqwyEArJUHPhZAAKhZPuVQBChdyDhmEYg+6+UKkuUv5KVToscTl2h2G2kHhrSAnMRYwWFlUqT6q6+botO4UkGKYtLl1im28k3xHcA63MzpKmqeqOKg93UPQPeQMwMVMoNqSr53nM2cJIomdPTzhGN4qvN/gtd7HNqfdsY4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UVOVo/0l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UVOVo/0l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rws42ckkqTkzgDuxRUNY3njePEBRVGzgiYWDAJf7PBI=; b=UVOVo/0luHBqwmh2QZx1wxwIY/
	hu58zpUtJw0wGB/QWwp4cdHOgHDAlvSY+NVY1LMGInsfWZRFLmzOU0F5BFEz31QSzEj8fC7o472w9
	hCuQP4DV9/pBeprydJmGaiC6z/NK2oPohr8PVbxN9c2hRf75abGI9xyh4bXx79qCM8vEvQKXuagGr
	+DPYmzKE++y2Pt99Jp1QEmFMYBoO9Fhi+rhAJL1O148lSTE8cVzGB9eklaL1jrQfzLKQzCXizqp16
	VRgNQq5FoiL+RflBRkdGV1CAgIVShlFYCpCrAqu63+vKwte0Io4VTvrj3PG/RgJSM70v4chBpuoiZ
	DgxT88vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uV3-00000000bOf-3sgy;
	Tue, 24 Mar 2026 05:40:21 +0000
Date: Mon, 23 Mar 2026 22:40:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acIjxUzWFstarlwv@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-53-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:41:07PM +0100, Jan Kara wrote:
> No filesystem calling __generic_file_fsync() uses metadata bh tracking.
> Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
> pointless now.

Given how much this changed, maybe rename it to simple_fsync now to
provide an obvious breakage for anyone trying to use it?  That name
is probably also better as it's not all that generic.

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/libfs.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 74134ba2e8d1..548e119668df 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1555,23 +1555,19 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
>  {
>  	struct inode *inode = file->f_mapping->host;
>  	int err;
> -	int ret;
> +	int ret = 0;
>  
>  	err = file_write_and_wait_range(file, start, end);
>  	if (err)
>  		return err;
>  
>  	inode_lock(inode);
> -	ret = sync_mapping_buffers(inode->i_mapping);
>  	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
>  		goto out;
>  	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
>  		goto out;
>  
> -	err = sync_inode_metadata(inode, 1);
> -	if (ret == 0)
> -		ret = err;
> -
> +	ret = sync_inode_metadata(inode, 1);
>  out:
>  	inode_unlock(inode);
>  	/* check and advance again to catch errors after syncing out buffers */
> -- 
> 2.51.0
> 
> 
---end quoted text---
