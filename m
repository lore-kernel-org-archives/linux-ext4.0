From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Forbid overflowing inode count when resizing
Date: Fri, 25 May 2018 12:50:57 -0400
Message-ID: <20180525165057.GC8197@thunk.org>
References: <20180524113646.3859-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jaco Kroon <jaco@uls.co.za>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180524113646.3859-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 24, 2018 at 01:36:46PM +0200, Jan Kara wrote:
> ext4_resize_fs() has an off-by-one bug when checking whether growing of
> a filesystem will not overflow inode count. As a result it allows a
> filesystem with 8192 inodes per group to grow to 64TB which overflows
> inode count to 0 and makes filesystem unusable. Fix it.
> 
> CC: stable@vger.kernel.org
> Fixes: 3f8a6411fbada1fa482276591e037f3b1adcf55b
> Reported-by: Jaco Kroon <jaco@uls.co.za>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

				- Ted
