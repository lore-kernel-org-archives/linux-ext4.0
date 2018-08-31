From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Fri, 31 Aug 2018 12:58:44 -0400
Message-ID: <20180831165844.GB3303@thunk.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
 <20180830163521.728f3ff2fd3cc93b52a5dcc0@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        konishi.ryusuke@lab.ntt.co.jp, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, axboe@kernel.dk, darrick.wong@oracle.com,
        ebiggers@google.com, pombredanne@nexb.com, agruenba@redhat.com,
        gregkh@linuxfoundation.org, kemi.wang@intel.com,
        willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nilfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830163521.728f3ff2fd3cc93b52a5dcc0@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2018 at 04:35:21PM -0700, Andrew Morton wrote:
> 
> The v1->v2 delta (below) reveals unchangelogged ext4 changes?

Souptick, please don't make unrelated changes in a vm_fault_t patch.

Especially please don't make whitespace changes that will cause
checkpatch.pl to whine about line lengths longer than 80 characters.
There's a *reason* for the original indentation.

> @@ -6239,8 +6237,7 @@ retry_alloc:
>  		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
>  	}
>  	ext4_journal_stop(handle);
> -	if (err == -ENOSPC &&
> -		ext4_should_retry_alloc(inode->i_sb, &retries))
> +	if (err == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry_alloc;
>  out_ret:
>  	ret = block_page_mkwrite_return(err);

The fact that this is not a non-trivials set of changes means anything
to make reviews harder is really not appreciated.


Also, the fact that the patch series involves multiple file system is
a massive pain.  It means I'm going to have to do a separate
regression test --- or preferably, I would ask *you* to run a file
system regression test[1] --- to make sure what is *not* a trivial
patch doesn't break things.  Also, it means that this patch series is
going to get more complicated to get into kernel, and we may have to
deal with patch conflicts if this goes in via some third party tree
(such as Andrew's tree).

[1] https:/thunk.org/gce-xfstests

One way to make life easier is to add the new function with the new
interface first, and then wait a release cycle, and then move file
systems over in independant patches.  

					- Ted
