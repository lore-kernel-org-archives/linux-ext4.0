Received: from smtp02-ext3.udag.de (smtp02-ext3.udag.de [62.146.106.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D86233121E;
	Tue, 24 Feb 2026 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.146.106.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771922208; cv=none; b=XRrBYQ3Rhj/2iMJOZ9s1qUvHfhBAPd99NySQ73j13nTQfdvDrOpI4ibSLOYVPAtwk+c8U4gelAXusP2rxtOO1enKu8i9EWRljwneoLOQCyL3voj1vAuPD41kzkpmCe2l87WpG1eyRw9c+AZn7UewD7hllsV8JpK91JeMelJ45iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771922208; c=relaxed/simple;
	bh=7mnOkl0qBsY0BUBWyCoFBzJO3ONHvC/fRvepJG//lvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUTKUpLFwwuy95egBZxFyM/Pyf0LaGfZo0c6qf1G/3/oB+yt/sEvnh5+0O1djNotszmxJmxDiPWR1r2jzvJ8KMDKDenh7mAAN9SMZWPjVNbEOBG6OdL4qhKJ7u0XPlA3BL7TMVdPtv0MomVo2ibPSAOMw8H4wacZGZ4b3qTiVcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=birthelmer.de; spf=pass smtp.mailfrom=birthelmer.de; arc=none smtp.client-ip=62.146.106.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=birthelmer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=birthelmer.de
Received: from localhost (200-143-067-156.ip-addr.inexio.net [156.67.143.200])
	by smtp02-ext3.udag.de (Postfix) with ESMTPA id D2488E078D;
	Tue, 24 Feb 2026 09:36:38 +0100 (CET)
Authentication-Results: smtp02-ext3.udag.de;
	auth=pass smtp.auth=birthelmercom-0001 smtp.mailfrom=horst@birthelmer.de
Date: Tue, 24 Feb 2026 09:36:38 +0100
From: Horst Birthelmer <horst@birthelmer.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, stable@vger.kernel.org, joannelkoong@gmail.com, 
	bpf@vger.kernel.org, bernd@bsbernd.com, neal@gompa.dev, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/5] fuse: quiet down complaints in fuse_conn_limit_write
Message-ID: <aZ1iT-KBp8Vt002k@fedora.fritz.box>
References: <177188733084.3935219.10400570136529869673.stgit@frogsfrogsfrogs>
 <177188733154.3935219.17731267668265272256.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <177188733154.3935219.17731267668265272256.stgit@frogsfrogsfrogs>

On Mon, Feb 23, 2026 at 03:06:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> gcc 15 complains about an uninitialized variable val that is passed by
> reference into fuse_conn_limit_write:
> 
>  control.c: In function ‘fuse_conn_congestion_threshold_write’:
>  include/asm-generic/rwonce.h:55:37: warning: ‘val’ may be used uninitialized [-Wmaybe-uninitialized]
>     55 |         *(volatile typeof(x) *)&(x) = (val);                            \
>        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
>  include/asm-generic/rwonce.h:61:9: note: in expansion of macro ‘__WRITE_ONCE’
>     61 |         __WRITE_ONCE(x, val);                                           \
>        |         ^~~~~~~~~~~~
>  control.c:178:9: note: in expansion of macro ‘WRITE_ONCE’
>    178 |         WRITE_ONCE(fc->congestion_threshold, val);
>        |         ^~~~~~~~~~
>  control.c:166:18: note: ‘val’ was declared here
>    166 |         unsigned val;
>        |                  ^~~
> 
> Unfortunately there's enough macro spew involved in kstrtoul_from_user
> that I think gcc gives up on its analysis and sprays the above warning.
> AFAICT it's not actually a bug, but we could just zero-initialize the
> variable to enable using -Wmaybe-uninitialized to find real problems.
> 
> Previously we would use some weird uninitialized_var annotation to quiet
> down the warnings, so clearly this code has been like this for quite
> some time.
> 
> Cc: <stable@vger.kernel.org> # v5.9
> Fixes: 3f649ab728cda8 ("treewide: Remove uninitialized_var() usage")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fuse/control.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 140bd5730d9984..073c2d8e4dfc7c 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -121,7 +121,7 @@ static ssize_t fuse_conn_max_background_write(struct file *file,
>  					      const char __user *buf,
>  					      size_t count, loff_t *ppos)
>  {
> -	unsigned val;
> +	unsigned val = 0;
>  	ssize_t ret;
>  
>  	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
> @@ -163,7 +163,7 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
>  						    const char __user *buf,
>  						    size_t count, loff_t *ppos)
>  {
> -	unsigned val;
> +	unsigned val = 0;
>  	struct fuse_conn *fc;
>  	ssize_t ret;
>  
> 
> 

This looks good to me. Trivial fix for an annoying problem.
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
