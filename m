From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: in fiemap use FIEMAP_EXTENT_LAST flag for last
 extent
Date: Fri, 03 Jun 2011 17:13:30 -0700
Message-ID: <4DE978AA.4090002@linux.vnet.ibm.com>
References: <1307128825-3013-1-git-send-email-lczerner@redhat.com> <1307128825-3013-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, k-mio@sx.jp.nec.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50320 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab1FDANi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2011 20:13:38 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5400ojl011358
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jun 2011 18:00:50 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p540DVPP346356
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jun 2011 18:13:31 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p540DUK7027962
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jun 2011 18:13:31 -0600
In-Reply-To: <1307128825-3013-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/3/2011 12:20 PM, Lukas Czerner wrote:
> Currently we are not marking the extent as the last one
> (FIEMAP_EXTENT_LAST) if there is a hole at the end of the file. This is
> because we just do not check for it right now and continue searching for
> next extent. But at the point we hit the hole at the end of the file, it
> is too late.
>
> This commit adds check for the allocated block in subsequent extent and
> if there is no more extents (block = EXT_MAX_BLOCKS) just flag the
> current one as the last one.
>
> This behaviour has been spotted unintentionally by 252 xfstest, when the
> test hangs out, because of wrong loop condition. However on other
> filesystems (like xfs) it will exit anyway, because we notice the last
> extent flag and exit.
>
> With this patch xfstest 252 does not hang anymore, ext4 fiemap
> implementation still reports bad extent type in some cases, however
> this seems to be different issue.
>
> Signed-off-by: Lukas Czerner<lczerner@redhat.com>
> ---
>   fs/ext4/ext4_extents.h |    2 +-
>   fs/ext4/extents.c      |    8 +++-----
>   2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> index 4764146..095c36f 100644
> --- a/fs/ext4/ext4_extents.h
> +++ b/fs/ext4/ext4_extents.h
> @@ -125,7 +125,7 @@ struct ext4_ext_path {
>    * positive retcode - signal for ext4_ext_walk_space(), see below
>    * callback must return valid extent (passed or newly created)
>    */
> -typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
> +typedef int (*ext_prepare_callback)(struct inode *, ext4_lblk_t,
>   					struct ext4_ext_cache *,
>   					struct ext4_extent *, void *);
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 4157570..f815cc8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1958,7 +1958,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>   			err = -EIO;
>   			break;
>   		}
> -		err = func(inode, path,&cbex, ex, cbdata);
> +		err = func(inode, next,&cbex, ex, cbdata);
>   		ext4_ext_drop_refs(path);
>
>   		if (err<  0)
> @@ -3914,14 +3914,13 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
>   /*
>    * Callback function called for each extent to gather FIEMAP information.
>    */
> -static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
> +static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
>   		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
>   		       void *data)
>   {
>   	__u64	logical;
>   	__u64	physical;
>   	__u64	length;
> -	loff_t	size;
>   	__u32	flags = 0;
>   	int		ret = 0;
>   	struct fiemap_extent_info *fieinfo = data;
> @@ -4103,8 +4102,7 @@ found_delayed_extent:
>   	if (ex&&  ext4_ext_is_uninitialized(ex))
>   		flags |= FIEMAP_EXTENT_UNWRITTEN;
>
> -	size = i_size_read(inode);
> -	if (logical + length>= size)
> +	if (next == EXT_MAX_BLOCKS)
>   		flags |= FIEMAP_EXTENT_LAST;
>
>   	ret = fiemap_fill_next_extent(fieinfo, logical, physical,

Hi Lukas,

I tried this patch and it fixed the 252 hang for me too.  This is a fix 
I needed to continue the tests that I am working on.  Thank you!  :)

Allison Henderson
