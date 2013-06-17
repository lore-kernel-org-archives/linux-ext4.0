From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fixed corruption when online resizing a fs with 1K
 block size
Date: Mon, 17 Jun 2013 09:07:03 -0400
Message-ID: <20130617130703.GD24972@thunk.org>
References: <1367856367-15924-1-git-send-email-maarten@treewalker.org>
 <20130508135825.GA3810@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Maarten ter Huurne <maarten@treewalker.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130508135825.GA3810@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 08, 2013 at 03:58:25PM +0200, Jan Kara wrote:
> On Mon 06-05-13 18:06:07, Maarten ter Huurne wrote:
> > Subtracting the number of the first data block places the superblock
> > backups one block too early, corrupting the file system. When the block
> > size is larger than 1K, the first data block is 0, so the subtraction
> > has no effect and no corruption occurs.
>   Looking where mke2fs places backup super blocks you are right. You can
> add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
