From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 0/12]ext4: online defrag (ver 0.95)
Date: Thu, 2 Oct 2008 04:26:10 -0400
Message-ID: <20081002082610.GA15597@infradead.org>
References: <48DDE025.2090207@rs.jp.nec.com> <20081001004053.GD3160@webber.adilger.int> <20081001184545.GA2096@infradead.org> <20081001212011.GG10080@mit.edu> <20081002081059.GO3160@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081002081059.GO3160@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 02, 2008 at 01:10:59AM -0700, Andreas Dilger wrote:
> We've been using that patch for a long time now in Lustre, but will soon
> be replacing it with code that calls fh_to_dentry() and just craft fake
> fh to have the filesystem open the inode.  That avoids all kinds of hacks
> in place internally.
> 
> Definitely the __iopen__ directory should only be allowed for root...

Well, the right way to do it is to actually pass in the FH from
userspace.  Open by inode # alone is not enough, you alwasy want the
generation, too.  And for some filesystems (e.g. reiserfs) the FH is
more complicated.  The interface for it would be two ioctls (or better
syscalls) to generate the FH and convert it back to an FD, and possibly
a third one for readlink by handle.

XFS had these since day 1, but I would neither recommend copying the API
or implementation as they are just messed up badly.
