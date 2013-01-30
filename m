From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix possible use-after-free with AIO
Date: Tue, 29 Jan 2013 22:51:25 -0500
Message-ID: <20130130035125.GB25006@thunk.org>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
 <1359502081-20240-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1359502081-20240-2-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 30, 2013 at 12:27:58AM +0100, Jan Kara wrote:
> Running AIO is pinning inode in memory using file reference. Once AIO
> is completed using aio_complete(), file reference is put and inode can
> be freed from memory. So we have to be sure that calling aio_complete()
> is the last thing we do with the inode.
> 
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> CC: stable@vger.kernel.org
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

I've picked up the ext4 change.  Sorry for not getting to this sooner.

     	       	   		       	   - Ted

