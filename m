From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/32] ext4: ea_inode owner should be the same as the
 inode owner
Date: Wed, 21 Jun 2017 21:28:26 -0400
Message-ID: <20170622012825.arh4lsnybfh4g3n6@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-6-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-6-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:16PM -0700, Tahsin Erdogan wrote:
> Quota charging is based on the ownership of the inode. Currently, the
> xattr inode owner is set to the caller which may be different from the
> parent inode owner. This is inconsistent with how quota is charged for
> xattr block and regular data block writes.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

					- Ted
