From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 15/19] ext4: Simplify error handling in
 ext4_dax_huge_fault()
Date: Fri, 13 Oct 2017 14:09:17 -0600
Message-ID: <20171013200917.GD29081@linux.intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-16-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-16-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 11, 2017 at 10:05:59PM +0200, Jan Kara wrote:
> If transaction starting fails, just bail out of the function immediately
> instead of checking for that condition throughout the function.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Yep, looks correct and is cleaner:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
