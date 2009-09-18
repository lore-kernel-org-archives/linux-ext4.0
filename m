From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Sat, 19 Sep 2009 01:59:52 +0200
Message-ID: <20090918235952.GE29406@nb.net.home>
References: <4AB2B6B9.7010506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZIRX7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 19:59:50 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8INxsam001384
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 19:59:54 -0400
Content-Disposition: inline
In-Reply-To: <4AB2B6B9.7010506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 17, 2009 at 05:22:49PM -0500, Eric Sandeen wrote:
> +static errcode_t ext2fs_get_device_geometry(const char *file,
> +					    struct ext2_super_block *fs_param)
> +{
> +	int fd;
> +	int rc = 1;
> +	int blocksize;
> +	blkid_probe pr;
> +	blkid_topology tp;
> +	unsigned long min_io;
> +	unsigned long opt_io;
> +
> +#ifdef HAVE_OPEN64
> +	fd = open64(file, O_RDONLY);
> +#else
> +	fd = open(file, O_RDONLY);
> +#endif
> +	if (fd < 0)
> +		return errno;
> +
> +	pr = blkid_new_probe();
> +	if (!pr)
> +		goto out;
> +
> +	rc = blkid_probe_set_device(pr, fd, 0, 0);
> +	if (rc)
> +		goto out;
> +
> +	tp = blkid_probe_get_topology(pr);
> +	if (!tp)
> +		goto out;
> +
> +	min_io = blkid_topology_get_minimum_io_size(tp);
> +	opt_io = blkid_topology_get_optimal_io_size(tp);
> +	blocksize = EXT2_BLOCK_SIZE(fs_param);
> +
> +	fs_param->s_raid_stride = min_io / blocksize;
> +	fs_param->s_raid_stripe_width = opt_io / blocksize;
> +	rc = 0;
> +out:

   blkid_free_probe(pr);

just in case you want to keep valgrind mem-leak checkers silent :-) 

> +	close(fd);
> +	return rc;
> +}

    Karel
-- 
 Karel Zak  <kzak@redhat.com>
