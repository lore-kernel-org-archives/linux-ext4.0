From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 4/5] dax: use sb_issue_zerout instead of calling dax_clear_sectors
Date: Fri, 15 Apr 2016 11:18:22 -0400
Message-ID: <x49y48e6gu9.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-5-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-nvdimm@ml01.01.org, Jens Axboe <axboe@fb.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
To: Vishal Verma <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1459303190-20072-5-git-send-email-vishal.l.verma@intel.com>
	(Vishal Verma's message of "Tue, 29 Mar 2016 19:59:49 -0600")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Vishal Verma <vishal.l.verma@intel.com> writes:

> From: Matthew Wilcox <matthew.r.wilcox@intel.com>
>
> dax_clear_sectors() cannot handle poisoned blocks.  These must be
> zeroed using the BIO interface instead.  Convert ext2 and XFS to use
> only sb_issue_zerout().
>
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> [vishal: Also remove the dax_clear_sectors function entirely]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
