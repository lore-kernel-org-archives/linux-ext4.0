From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] xfs: factor out everything but the
 filemap_write_and_wait from xfs_file_fsync
Date: Wed, 21 Nov 2012 05:09:13 -0500
Message-ID: <20121121100913.GF23339@infradead.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120074138.24645.36708.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com,
	jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk,
	jack@suse.cz, linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121120074138.24645.36708.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
> Hi,
> 
> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
> function that can be used from the I/O post-processing path.

Why would we need to skip the filemap_write_and_wait_range call here?
If we're doing direct I/O we should not have any pages in this regions
anyway.  You're also not skipping it in the generic implementation as
far as I can see, so I see no point in doing it just in XFS.
