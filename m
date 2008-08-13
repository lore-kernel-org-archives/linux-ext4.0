From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio
	writereturningEIOwhentry_to_release_page fails
Date: Wed, 13 Aug 2008 08:59:56 -0400
Message-ID: <1218632396.15342.340.camel@think.oraclecorp.com>
References: <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
	 <1218063477.6383.41.camel@mingming-laptop>
	 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
	 <1218104494.15342.171.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
	 <1218200055.15342.230.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
	 <1218547706.15342.305.camel@think.oraclecorp.com>
	 <20080813101650.GA14392@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zach Brown <zach.brown@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080813101650.GA14392@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2008-08-13 at 12:16 +0200, Jan Kara wrote:

> > With that said, I don't have strong feelings against falling back to
> > buffered IO when the invalidate fails.  Maybe Zach remembers something I
> > don't?
>   I don't have a strong opinion either. Falling back to buffered writes is
> simpler at least for ext3/ext4 because properly synchronizing against
> writepage() call does not seem to have a nice solution either in
> do_launder_page() or in releasepage(). OTOH is hides the fact the invalidate
> is failing and so if we screw up something in future and it fails often, it
> might be hard to notice / track down the performance penalty.

In general, these races don't happen often, and when they do it is
because someone is mixing page cache and O_DIRECT io to the same file.
That is explicitly outside the main use case of O_DIRECT.

So, I'd rather see us slow down O_DIRECT in the mixed use case than have
big impacts in complexity or speed to other parts of the kernel.  If
falling back avoids problems in some filesystems or avoids clearing the
uptodate bit unexpectedly, I'd much rather take the fallback patch.

-chris


