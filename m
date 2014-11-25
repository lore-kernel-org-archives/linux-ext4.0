From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Date: Tue, 25 Nov 2014 09:01:00 -0800
Message-ID: <20141125170100.GA1553@infradead.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <20141124152101.GA12575@infradead.org>
 <20141124173430.GB26471@twin.jikos.cz>
 <20141125155141.GF26471@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141125155141.GF26471@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 25, 2014 at 04:51:41PM +0100, David Sterba wrote:
> Does not work because the security.* and system.* namespaces do not call
> the permission() hook, so no patch. However, if the proposed
> inode_is_readonly callback is merged, we can replace the btrfs-specific
> checks with is_readonly check in xattr_permission().

I think that patch should go first in the series.  But I really need to
find some time to review the whole thing before commenting with profound
half-knowledge..
