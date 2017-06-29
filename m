From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH v8 03/18] fs: check for writeback errors after syncing
 out buffers in generic_file_fsync
Date: Thu, 29 Jun 2017 16:17:23 -0400
Message-ID: <1498767443.5710.1.camel@poochiereds.net>
References: <20170629131954.28733-1-jlayton@kernel.org>
	 <20170629131954.28733-4-jlayton@kernel.org>
	 <20170629141933.GE17251@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@ZenIV.linux.org.uk>,  Jan Kara <jack@suse.cz>, tytso@mit.edu,
 axboe@kernel.dk, mawilcox@microsoft.com,  ross.zwisler@linux.intel.com,
 corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
 David Sterba <dsterba@suse.com>, "Darrick J . Wong"
 <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu
 Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Liu Bo
 <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, jlayton@kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170629141933.GE17251@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2017-06-29 at 07:19 -0700, Christoph Hellwig wrote:
> On Thu, Jun 29, 2017 at 09:19:39AM -0400, jlayton@kernel.org wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> > 
> > ext2 currently does a test+clear of the AS_EIO flag, which is
> > is problematic for some coming changes.
> > 
> > What we really need to do instead is call filemap_check_errors
> > in __generic_file_fsync after syncing out the buffers. That
> > will be sufficient for this case, and help other callers detect
> > these errors properly as well.
> > 
> > With that, we don't need to twiddle it in ext2.
> 
> Seems like much of this code is getting replaced later in the
> series..


It does. I suppose I could squash this in with the __generic_file_fsync
patch.

-- 
Jeff Layton <jlayton@poochiereds.net>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
