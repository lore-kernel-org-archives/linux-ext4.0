From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/32] ext4: fix ext4_xattr_make_inode_space() value size
 calculation
Date: Wed, 21 Jun 2017 22:09:39 -0400
Message-ID: <20170622020939.yfzzsxivpsidcstg@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-14-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-14-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:24PM -0700, Tahsin Erdogan wrote:
> ext4_xattr_make_inode_space() is interested in calculating the inline
> space used in an inode. When a xattr entry refers to an external inode
> the value size indicates the external inode size, not the value size in
> the inline area. Change the function to take this into account.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applued.

				- Ted
