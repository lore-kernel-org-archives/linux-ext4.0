From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/32] ext4: call journal revoke when freeing ea_inode
 blocks
Date: Wed, 21 Jun 2017 21:38:07 -0400
Message-ID: <20170622013807.uqkuhqu2m7ob2zc7@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-7-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-7-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:17PM -0700, Tahsin Erdogan wrote:
> ea_inode contents are treated as metadata, that's why it is journaled
> during initial writes. Failing to call revoke during freeing could cause
> user data to be overwritten with original ea_inode contents during journal
> replay.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

						- Ted
