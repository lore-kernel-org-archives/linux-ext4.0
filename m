From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/32] ext4: ext4_xattr_delete_inode() should return
 accurate errors
Date: Wed, 21 Jun 2017 22:27:43 -0400
Message-ID: <20170622022743.c36eiwo6dl3t2uuv@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-19-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-19-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:29PM -0700, Tahsin Erdogan wrote:
> In a few places the function returns without trying to pass the actual
> error code to the caller. Fix those.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

					- Ted
