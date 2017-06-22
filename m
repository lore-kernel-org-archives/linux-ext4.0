From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 24/32] ext2, ext4: make mb block cache names more explicit
Date: Thu, 22 Jun 2017 11:30:00 -0400
Message-ID: <20170622153000.vz5mjqkfmcd66gaj@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:31PM -0700, Tahsin Erdogan wrote:
> There will be a second mb_cache instance that tracks ea_inodes. Make
> existing names more explicit so that it is clear that they refer to
> xattr block cache.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
