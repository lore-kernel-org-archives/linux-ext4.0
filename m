From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 31/32] ext4: strong binding of xattr inode references
Date: Thu, 22 Jun 2017 11:54:24 -0400
Message-ID: <20170622155424.jj6c3fglp3vehddq@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-8-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-8-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:38PM -0700, Tahsin Erdogan wrote:
> To verify that a xattr entry is not pointing to the wrong xattr inode,
> we currently check that the target inode has EXT4_EA_INODE_FL flag set and
> also the entry size matches the target inode size.
> 
> For stronger validation, also incorporate crc32c hash of the value into
> the e_hash field. This is done regardless of whether the entry lives in
> the inode body or external attribute block.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Added to the ext4 patch queue, thanks.

					- Ted
