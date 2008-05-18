From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sat, 17 May 2008 21:36:41 -0400
Message-ID: <20080518013641.GH16496@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <200805172048.34455.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200805172048.34455.chris.mason@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 17, 2008 at 08:48:33PM -0400, Chris Mason wrote:
> 
> Well, the barriers happen like so (even if we actually only do one
> barrier in submit_bh, it turns into two)
> 
> write log blocks
> flush #1
> write commit block
> flush #2
> write metadata blocks
> 
> I'd agree with Ted, there's a fairly small chance of things get reordered 
> around flush #1.  flush #2 is likely to have lots of reordering though.  It 
> should be easy to create situations where the metadata for a transaction is 
> written before the log blocks ever see the disk.

True, but even with a very heavy fsync() workload, a commit doesn't
cause the metadata blocks to be written until we have to do a journal
truncate operation.  A heavy fsync() workload would increase how
quickly we would use up the journal and need to do a journal truncate,
though.

> EMC did a ton of automated testing around this when Jens and I did
> the initial barrier implementations, and they were able to trigger
> corruptions in fsync heavy workloads with randomized power offs.
> I'll dig up the workload they used.

I could imagine a mode which forces a barrier operation for commits
triggered by fsync()'s, but not commits that occur due to a natural
closing of transactions.  I'm not sure it's worth it, though, since
many of the benchmarks that we care about (like Postmark) do use
fsync() fairly heavily.

The really annoying thing is that what is really needed is a way to
make write barriers cheaper; we don't need to do a synchronous flush,
but unfortunately for most drives there isn't any other way of keeping
disk writes from getting reordered.

							- Ted
