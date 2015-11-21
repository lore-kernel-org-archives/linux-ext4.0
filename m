From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
 output
Date: Sat, 21 Nov 2015 10:06:44 -0800
Message-ID: <20151121180644.GA23916@infradead.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
 <20151121005014.20398.22316.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
	hch@infradead.org, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151121005014.20398.22316.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> --- a/tests/generic/158.out
> +++ b/tests/generic/158.out
>  Try to dedupe a device
> -XFS_IOC_FILE_EXTENT_SAME: Permission denied
> +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
>  Try to dedupe to a dir
> -/mnt/test-158/dir1: Is a directory
> +TEST_DIR/test-158/dir1: Is a directory
>  Try to dedupe to a device
> -dedupe: Permission denied
> +dedupe: Operation not supported
>  Try to dedupe to a fifo
> -dedupe: Permission denied
> +dedupe: Operation not supported

Shouldn't these be Invalid argument just like the
to a device case above or the clone case?

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
