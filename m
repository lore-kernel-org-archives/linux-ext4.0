From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Tue, 20 May 2008 16:43:14 +0100
Message-ID: <20080520154313.GI16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080520023454.GM15035@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
> > To ensure that bits are truly on-disk after an fsync,
> > we should call blkdev_issue_flush if barriers are supported.
> 
> This patch isn't necessary, and in fact will cause a double flush.
> When you call fsync(), it calls ext4_force_commit(), and we do a the
> equivalent of a blkdev_issue_flush() today (which is what happenes
> when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
> set_ordered_mode(bh) ends up causing.

ISTR fsync() on ext3 did not always force a commit, if in-place data
writes did not change any metadata.  Has this been fixed in ext4 but
not ext3 then?

Does WRITE_BARRIER always cause a flush?  It does not have to
according to Documentation/block/barrier.txt.  There are caveats about
tagged queuing "not yet implemented" in the text, but can we rely on
that?  The documentation is older than the current implementation;
those caveats might no longer apply.

-- Jamie
