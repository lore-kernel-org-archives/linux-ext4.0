From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: fix quota charging for shared xattr blocks
Date: Wed, 24 May 2017 18:25:41 -0400
Message-ID: <20170524222541.bmefxdhbdhle4in2@thunk.org>
References: <20170524090658.GD10604@quack2.suse.cz>
 <20170524113519.16232-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170524113519.16232-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 24, 2017 at 04:35:19AM -0700, Tahsin Erdogan wrote:
> ext4_xattr_block_set() calls dquot_alloc_block() to charge for an xattr
> block when new references are made. However if dquot_initialize() hasn't
> been called on an inode, request for charging is effectively ignored
> because ext4_inode_info->i_dquot is not initialized yet.
> 
> Add dquot_initialize() to call paths that lead to ext4_xattr_block_set().
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
