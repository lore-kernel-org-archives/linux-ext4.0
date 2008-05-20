From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Tue, 20 May 2008 21:54:37 +0200
Message-ID: <20080520195437.GZ22369@kernel.dk>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080520154313.GI16676@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 20 2008, Jamie Lokier wrote:
> Does WRITE_BARRIER always cause a flush?  It does not have to
> according to Documentation/block/barrier.txt.  There are caveats about
> tagged queuing "not yet implemented" in the text, but can we rely on
> that?  The documentation is older than the current implementation;
> those caveats might no longer apply.

It does, if you use ordered tags then that assumes write through
caching (or ordered tag + drain + flush after completion).

-- 
Jens Axboe

