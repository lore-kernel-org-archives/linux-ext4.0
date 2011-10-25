From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: ext4_dx_add_entry should dirty directory
 metadata with the directory inode
Date: Tue, 25 Oct 2011 09:13:24 -0400
Message-ID: <20111025131324.GJ31921@thunk.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2011 at 02:17:59PM -0700, Darrick J. Wong wrote:
> ext4_dx_add_entry manipulates bh2 and frames[0].bh, which are two buffer_heads
> that point to directory blocks assigned to the directory inode.  However, the
> function calls ext4_handle_dirty_metadata with the inode of the file that's
> being added to the directory, not the directory inode itself.  Therefore,
> correct the code to dirty the directory buffers with the directory inode, not
> the file inode.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This has been accpeted into the ext4 tree already (git commit:
5930ea643 in the master branch)

						- Ted
