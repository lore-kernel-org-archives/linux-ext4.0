From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v5 08/17] dax: set errors in mapping when writeback fails
Date: Mon, 05 Jun 2017 21:08:26 -0400
Message-ID: <1496711306.2815.0.camel@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
         <20170531124540.8782-9-jlayton@redhat.com>
         <20170606010153.GA7489@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        corbet@lwn.net, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170606010153.GA7489@linux.intel.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-06-05 at 19:01 -0600, Ross Zwisler wrote:
> On Wed, May 31, 2017 at 08:45:31AM -0400, Jeff Layton wrote:
> > Jan's description for this patch is much better than mine, so I'm
> > quoting it verbatim here:
> > 
> > -----------------8<-----------------
> > DAX currently doesn't set errors in the mapping when cache flushing
> > fails in dax_writeback_mapping_range(). Since this function can get
> > called only from fsync(2) or sync(2), this is actually as good as it can
> > currently get since we correctly propagate the error up from
> > dax_writeback_mapping_range() to filemap_fdatawrite()
> > 
> > However, in the future better writeback error handling will enable us to
> > properly report these errors on fsync(2) even if there are multiple file
> > descriptors open against the file or if sync(2) gets called before
> > fsync(2). So convert DAX to using standard error reporting through the
> > mapping.
> > -----------------8<-----------------
> > 
> > For now, only do this when the FS_WB_ERRSEQ flag is set. The
> > AS_EIO/AS_ENOSPC flags are not currently cleared in the older code when
> > writeback initiation fails, only when we discover an error after waiting
> > on writeback to complete, so we only want to do this with errseq_t based
> > error handling to prevent seeing duplicate errors on fsync.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-and-Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Re-tested this version of the series with some injected DAX errors, and it
> looks good.

Excellent! Thanks very much for helping test it.

-- 
Jeff Layton <jlayton@redhat.com>
