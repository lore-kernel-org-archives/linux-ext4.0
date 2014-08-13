From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Wed, 13 Aug 2014 09:22:22 -0400
Message-ID: <20140813132222.GB6437@thunk.org>
References: <CAPTn0cDY+sYFpFnPQmpLRCDdtvc3rThgNzSkevcyYkcia=poew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cDY+sYFpFnPQmpLRCDdtvc3rThgNzSkevcyYkcia=poew@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 13, 2014 at 10:32:31AM +0800, Li Xi wrote:
> Yeah, we were using non-journaled quota. And we were doing this
> benchmark to confirm that xattr based implementation has extra
> overhead. We will run benchmarks on journaled-quota, and let's see
> what is the performance difference between non-journaled and
> journaled quotas.

Can you give a lot of details about exactly how you ran the benchmark
(and run future benchmarks)?  Was this on a ramdisk?  An SSD?  A HDD?
How many CPU's, how many threads were creating files, etc.  And do you
understand where the performance overhead was coming from?  Was it CPU
overhead?  Locking overhead?

It just doesn't make sense that storing the value in the xattr, when
the xattr is stored in the on-disk inode, that it should make a huge
difference; the cost of the I/O should completely dominate the cost of
whether we format the bytes as an integer or storing it in the
in-inode xattr.  So either there is a bug in the benchmark, or a bug
in our code somewhere.  Either way, we should find and fix it.

Regards,

						- Ted
