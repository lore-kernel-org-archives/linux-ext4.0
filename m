From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v2 0/5] add support for a lazytime mount option
Date: Mon, 24 Nov 2014 01:07:55 -0800
Message-ID: <20141124090755.GA28534@infradead.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416675267-2191-1-git-send-email-tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

What's the test coverage for this?  xfstest generic/192 tests that
atime is persisted over remounts, which we had a bug with when XFS
used to have a lazy atime implementation somewhat similar to the
proposal.

We should have something similar for c/mtime as well.  Also a test to
ensure timestamps are persisted afer a fsync, although right now I can't
imagine how to do that genericly as no other filesystem seems to have
an equivaent to XFS_IOC_GOINGDOWN.

It seems you also handle i_version updates lazily. although that's
not mentioned anywhere.  I actually have a clarification request out on
the IETF NFSv4 list about the persistance requirements for the change
counter but I've not seen an answer to it yet.
