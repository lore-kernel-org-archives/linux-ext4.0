From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Wed, 18 May 2011 14:13:21 -0400
Message-ID: <20110518181321.GC10163@infradead.org>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>, tytso@mit.edu,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305731882-8334-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 18, 2011 at 05:17:59PM +0200, Jan Kara wrote:
> from Christoph in the patches which resulted in some patch reorg. I'd like to
> get these patches reviewed and then get them merged possibly via ext4-tree
> (although the first two patches might go via Al but that would complicate
> merging of ext4 part where I expect more conflicts with ongoing work).

The core canges are clear VFS tree material, and given that they are
needed for the stable pages patches as well it really doesn't make sense
to funnel this through a fs tree.  It might make sense to include the
ext4 patch in the VFS pile if that makes merging easier.

