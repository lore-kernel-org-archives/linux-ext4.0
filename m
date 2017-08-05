From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix SEEK_HOLE/SEEK_DATA for blocksize < pagesize
Date: Sat, 5 Aug 2017 18:10:20 -0400
Message-ID: <20170805221020.iehq3ntki6rbs4in@thunk.org>
References: <20170728111637.12473-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170728111637.12473-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 28, 2017 at 01:16:37PM +0200, Jan Kara wrote:
> ext4_find_unwritten_pgoff() does not properly handle a situation when
> starting index is in the middle of a page and blocksize < pagesize. The
> following command shows the bug on filesystem with 1k blocksize:
> 
>   xfs_io -f -c "falloc 0 4k" \
>             -c "pwrite 1k 1k" \
>             -c "pwrite 3k 1k" \
>             -c "seek -a -r 0" foo
> 
> In this example, neither lseek(fd, 1024, SEEK_HOLE) nor lseek(fd, 2048,
> SEEK_DATA) will return the correct result.
> 
> Fix the problem by neglecting buffers in a page before starting offset.
> 
> Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
