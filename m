Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43097453A36
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790101122; cv=none; b=ANE+ntpjhUDY+scuGyOFWLCeA0SKh2iEjgBZc0cuIsDZv2yj9iaSZ4v7oK81uJj/gD2w7jd1NOMaFKYwJpTJ+jEoLyK31slULMrcfabtA7P1h2n1KcD4kfScT1HplPvN4MtqCLGZEQgOOGle19haUXIs23VbgCo3LyvRDjKCo5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790101122; c=relaxed/simple;
	bh=3hUAeXZFWGYox8yZs6s10dhcJK71N2z8ZSL4k59cY80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfY+WepcxWFIdWKoFUR/vitV9vO2qzHhcjs54OrLLTNWNMbXKQtiC3dTcEZDhD970uFejkG1J8NBgauiHP31ESp2P6v+nWJ/yMVnRff5jDlveW31LQfcEfS9V2Gknq7sGGYpH7Xn49ZfUCytn60Fzm4XjxXl/bLTndr6RO6BKos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3MEzjKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3MEzjKS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9C7901F000FF;
	Tue, 22 Sep 2026 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790101120;
	bh=mXWug5GHINtSRKoxoJ9YheKk48a90lr+lAkuS9q9hlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e3MEzjKSHVmLd6ktzO6aXC5OsLT2EUZ13ZKuDIXdeBZxckpq0k5e7h/nR0gQA4GKl
	 MIsH4eKauJCM89gMWTwNjRnT6o8Oug8n5itijEJlG9jaKCQJpKSqP40jiIpBLqGkH6
	 dVKARmsjQqqE8H/QzEqcE/1Q9d+ZYojfMTgM0gSn0N6fCsILtiquNt8CsyRWsSwTFe
	 GIazugEmD2pX+1RRLI58yIMzWibNQThdV27RQOU64p/naA7xdtYhSBaN+lLM6PKPmg
	 4vPuhF2nMPNeSVKd6iVgJD9vJOH2FdXG36RKbyZB1c+2Wp4xIHBgQ6zUnM391Yxr12
	 jKHMUTkYtnhCQ==
Date: Tue, 22 Sep 2026 11:18:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 1/2] libext2fs: fix self-deadlock in
 flush_cached_blocks() write-error retry
Message-ID: <20260922181840.GC6239@frogsfrogsfrogs>
References: <20260922110435.1528332-1-matthias.goergens@gmail.com>
 <20260922110435.1528332-2-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110435.1528332-2-matthias.goergens@gmail.com>

On Tue, Sep 22, 2026 at 07:04:34PM +0800, Matthias Goergens wrote:
> flush_cached_blocks() drops CACHE_MTX before invoking the channel's
> write_error handler, then re-acquires it and jumps to the retry label.
> The retry label is above the while loop, whose first statement acquires
> CACHE_MTX again:
> 
>   retry:
> 	while (errors_found) {
> 		if ((flags & FLUSH_NOLOCK) == 0)
> 			mutex_lock(data, CACHE_MTX);		<- second
> 		...
> 				mutex_unlock(data, CACHE_MTX);
> 				(channel->write_error)(...);
> 				...
> 				mutex_lock(data, CACHE_MTX);		<- first
> 				goto retry;
> 
> The mutex is created with pthread_mutex_init(..., NULL), so it is not
> recursive and the second acquisition blocks the thread that already
> holds it.  The first flush that has to report a write error through a
> registered handler deadlocks, every time.
> 
> Found by fuzzing e2fsck with corrupt images.  An image whose group
> descriptors force bitmap relocation makes e2fsck -fn fail hundreds of
> writes on the read-only device; the aborted run reaches fatal_error(),
> whose io_channel_flush() enters this loop.  e2fsck then sleeps forever
> at 0% CPU and does not respond to SIGTERM, so an init script waiting on
> fsck waits indefinitely.  Read-only checking is enough to reach it.
> 
>   unfixed:  killed after 35s, no progress
>   fixed:    exits 12 after 13ms
> 
> Drop the redundant acquisition; the loop head takes the lock.
> 
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
>  lib/ext2fs/unix_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index abd33ba..29968e3 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -738,7 +738,7 @@ retry:
>  					retval2);
>  				if (err_buf)
>  					ext2fs_free_mem(&err_buf);
> -				mutex_lock(data, CACHE_MTX);
> +				/* the loop head re-acquires CACHE_MTX */

Yep, looks correct.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  				goto retry;
>  			} else
>  				cache->write_err = 0;
> -- 
> 2.55.0
> 
> 
