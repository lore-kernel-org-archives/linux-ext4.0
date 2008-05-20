From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 15:45:50 +0100
Message-ID: <20080520144550.GB16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <20080516225304.GG15334@shareable.org> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <20080517134344.GA7411@mit.edu> <20080517204437.GB16496@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vge
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080517204437.GB16496@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> Also, looking more closely on the jbd2 implementation, it looks like
> using the async_commit option, which relies on the checksum for more
> efficient commit, completely disables any barrier support.  That's
> because the only place we go into ordered more is if we are writing a
> synchronous journal commit.  If async journal commit is enabled, then
> we don't write a barrier at all, which leaves us in potential trouble
> with if data blocks end up getting reordered with respect to the
> journal commit in data=ordered more.

That is a great optimisation to make the filesystem safe against power
fails without barriers.  Upon replay, the filesystem is consistent.

But does it break fsync()?  Consistency isn't enough for fsync().
Returning from fsync() means "this data is committed now".

-- Jamie
