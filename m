From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/32] ext4: fix ext4_xattr_move_to_block()
Date: Wed, 21 Jun 2017 22:13:17 -0400
Message-ID: <20170622021317.sg2mp6pw45qhxolc@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-15-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-15-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:25PM -0700, Tahsin Erdogan wrote:
> When moving xattr entries from inline area to a xattr block, entries
> that refer to external xattr inodes need special handling because
> value data is not available in the inline area but rather should be
> read from its external inode.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
