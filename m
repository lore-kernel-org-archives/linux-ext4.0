From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/7] ext4: Mark superblock writes synchronous for
 nobarrier mounts
Date: Thu, 4 May 2017 11:00:17 -0400
Message-ID: <20170504150017.jz2jwp4iomdkrznc@thunk.org>
References: <20170502150351.29452-1-jack@suse.cz>
 <20170502150351.29452-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502150351.29452-2-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 02, 2017 at 05:03:45PM +0200, Jan Kara wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_FUA implementation.
> generic_make_request_checks() however strips REQ_FUA flag from a bio
> when the storage doesn't report volatile write cache and thus write
> effectively becomes asynchronous which can lead to performance
> regressions. This affects superblock writes for ext4. Fix the problem
> by marking superblock writes always as synchronous.
> 
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
