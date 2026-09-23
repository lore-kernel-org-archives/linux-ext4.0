Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9635531AF1;
	Wed, 23 Sep 2026 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183640; cv=none; b=XhiVOOCvJ0KYdqZwMKBZH1zk7jwYbPGqe9ubnihxuF+RoHD1206I6ZslGd5jbReKo/wcR10qWjqk+EuftT62V2baMvm+SA9bwB/45iSkKcMzHeAbsxngePzJIlUTkEh9AXSw4OJefxvbGUKaDJbj+ek7p8SaVFhhNnZAgEXhcfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183640; c=relaxed/simple;
	bh=tPRUaf96TfLPNRl5Uw7OBoMtNPH0JwCoVuV6H/1Q6CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfYNlSRefyFH9+YkfZl2AA/RgCA6UNX4An1A2PRwIY7hWKOrpc5CeQIW2CHHR/T/ZKo/tT8EQ1pVrnWjxH0HWWS3Fz01PuWG6KJ+wPq7gxCyiYlkuqbTcVZYNXzecvlkL6vbUWv2vou0eqlRtxqM5eROovGzmL/lSYbFVERHrwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBEaUd/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBEaUd/x"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4BA961F000FF;
	Wed, 23 Sep 2026 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183638;
	bh=yzuZ1CWAkwwNNum08LPfSmy4mnV6fJG+qkDewiFeS0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mBEaUd/xiz8hI0esN3/NlDk91OITIlZM28pln+CA/rMgT4+7i3aVylzBmmm/0R+zc
	 gV6rat3oYj/U8VNzxGuXqveEKvzN1IXJh1Wk8MyGp9ab1wjlE6kQV8Vvu9/Fim/3gU
	 UhjOLVo/uszzWeGflYW/SnNOW6qS8StsQdzBZNQNlqaT3yrqTUE3GCxsmx52EIHRRB
	 N85yXkSE6xWqhJqF8hQI12BEMVgOXzCe5q7upCwRRJTkEDxzxxyKt6YWUmCeRDwpT2
	 wBPUlHbrJmkTgOZZsYS+DfkVBfjadhklJnXNogS2/LOi/OYDv3IYLiPTWobahnNnCp
	 A74BK4/7Ui4oQ==
Date: Wed, 23 Sep 2026 10:13:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH e2fsprogs] tune2fs: touch the device node after setting
 the label via ioctl
Message-ID: <20260923171357.GD6239@frogsfrogsfrogs>
References: <20260923132223.3355764-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923132223.3355764-1-libaokun@linux.alibaba.com>

[cc linux-fsdevel]

On Wed, Sep 23, 2026 at 09:22:23PM +0800, Baokun Li wrote:
> When the file system is mounted, tune2fs sets the label through
> FS_IOC_SETFSLABEL, which updates the label without touching the
> mtime of the device node.  Consumers such as blkid use that mtime
> to validate their cached superblock information, so the old label
> can still be returned right after the change:
> 
>   blkid -s LABEL /dev/sdb    # gets "old" and caches it
>   tune2fs -L new /dev/sdb    # online path, node mtime unchanged
>   blkid -s LABEL /dev/sdb    # still gets "old" within 2s
> 
> The offline path is unaffected because writing the superblock
> through the device node updates its mtime as a side effect.  The
> ioctl path has no such side effect, so add an explicit utime() on
> the device after a successful FS_IOC_SETFSLABEL.
> 
> The return value is ignored; if the touch fails, the behavior is
> no worse than before.
> 
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://patch.msgid.link/arKZu30pMe0ZavVA@mit.edu
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> ---
>  misc/tune2fs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 2d85fb704e15..87b8e6830bb9 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -48,6 +48,7 @@ extern int optind;
>  #endif
>  #include <string.h>
>  #include <time.h>
> +#include <utime.h>
>  #include <unistd.h>
>  #include <sys/types.h>
>  #include <libgen.h>
> @@ -3167,6 +3168,14 @@ static int handle_fslabel(int setlabel)
>  		return 1;
>  	}
>  	close(fd);
> +
> +	/*
> +	 * FS_IOC_SETFSLABEL does not touch the device mtime that
> +	 * blkid uses to validate its cache; touch the device so
> +	 * mtime-based consumers see the change.
> +	 */
> +	utime(device_name, NULL);

For everyone on fsdevel who might be seeing this for the first time,
there was a problem report in which it was discovered that the libblkid
cache invalidates its knowledge if something updates the block device
mtime.  This is done whenever userspace tools update a block device
(e.g. mkfs) but not done by the kernel when it rewrites the primary
superblock (e.g. FS_IOC_SETFSLABEL).

This patch fixes tune2fs to add the missing mtime update, but I think
a better way to solve this is to fix the ~8 or so implementations inside
the kernel.  And maybe the FS_IOC_SETFSUUID implementations too.

A bigger question, then, is whether filesystems should bump mtime /any/
time they update their own superblock?  There aren't any published specs
mandating this behavior by the kernel, but I suppose it falls under
"someone observed a behavior and started relying on it" :P

Thoughts?

--D

[1] https://lore.kernel.org/linux-ext4/20260920094137.2749428-1-libaokun@linux.alibaba.com/

> +
>  	return 0;
>  #else
>  	return -1;
> -- 
> 2.43.7
> 
> 
