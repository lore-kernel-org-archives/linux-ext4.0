From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/3] ext4: test for inline data + DAX corruption
Date: Wed, 13 Sep 2017 15:16:35 +0800
Message-ID: <20170913071635.GB8034@eguan.usersys.redhat.com>
References: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
 <20170912044521.22644-3-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-xfs@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912044521.22644-3-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 11, 2017 at 10:45:21PM -0600, Ross Zwisler wrote:
> Add a regression test for the following kernel commit:
> 
>   ext4: prevent data corruption with inline data + DAX
> 
> The test passes either if we don't encounter corruption, or if mounting
> with DAX + inline data fails.  The latter is the way that we prevent this
> issue in the kernel.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Besides the gitignore entry order issue and call the test program from
$here/src/... issue, need another require rule:

_require_ext4_mkfs_feature "inline_data"

Otherwise this looks fine to me.

Thanks,
Eryu
