From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/32] mbcache: make mbcache naming more generic
Date: Thu, 22 Jun 2017 10:37:02 -0400
Message-ID: <20170622143702.6sgff5xnc5sxux6i@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-23-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-23-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:33PM -0700, Tahsin Erdogan wrote:
> Make names more generic so that mbcache usage is not limited to
> block sharing. In a subsequent patch in the series
> ("ext4: xattr inode deduplication"), we start using the mbcache code
> for sharing xattr inodes. With that patch, old mb_cache_entry.e_block
> field could be holding either a block number or an inode number.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

					- Ted
