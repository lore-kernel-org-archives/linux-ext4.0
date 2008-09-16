From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Tue, 16 Sep 2008 18:03:46 -0400
Message-ID: <20080916220346.GB10562@mit.edu>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080916064514.GH3241@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 15, 2008 at 11:49:43PM -0700, Andreas Dilger wrote:
> The intent of this flag was a "catch-all" to indicate it isn't safe
> to try and read this block from disk, either because it is encrypted,
> compressed, on a remote system (HSM or over a network), or maybe not
> even written to disk yet (delalloc).
> 
> In some cases (e.g. dump on a snapshot, or boot with LILO) it IS ok to
> read directly from a block device underneath the filesystem, but that
> would completely fail for the above cases.

Indeed, I thought it was pretty clear and obvious, but let me give an
quick but formal definition, and a potential name: DATA_ENCODED

If this flag is not set, then applications that who wish to access the
file data may do so by accessing the block device at the indicated
offset when the filesystem is unmounted.  If the filesystem is
mounted, it is undefined whether accessing via the block device will
return valid data.  If the flag DATA_ENCODED flag is set, it is almost
certain that an application will never be able to access the file data
via the block device.

Would this make people happy?

						- Ted
