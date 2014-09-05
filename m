From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv4 2/3] ext4: use non-movable memory for the ext4
 superblock
Date: Thu, 4 Sep 2014 22:37:36 -0400
Message-ID: <20140905023736.GB1971@thunk.org>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <1409815781-28011-3-git-send-email-gioh.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, js1304@gmail.com,
	gunho.lee@lge.com
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409815781-28011-3-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 04, 2014 at 04:29:40PM +0900, Gioh Kim wrote:
> A buffer-cache for superblock is disturbing page migration,
> because the buffer-cache is not released until unmount.
> The buffer-cache must be allocated from non-movable area.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, I've applied this to the ext4 git tree with a slightly
rewritten commit description (for clarity).

						- Ted
