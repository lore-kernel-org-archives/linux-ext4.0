From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v7 01/22] fs: remove call_fsync helper function
Date: Mon, 26 Jun 2017 10:05:26 +0200
Message-ID: <20170626080526.ufetu6blf2kllihn@eorzea.usersys.redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-2-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170616193427.13955-2-jlayton@redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 16, 2017 at 03:34:06PM -0400, Jeff Layton wrote:
> Requested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/sync.c          | 2 +-
>  include/linux/fs.h | 6 ------
>  ipc/shm.c          | 2 +-
>  3 files changed, 2 insertions(+), 8 deletions(-)
> 
> 2.13.0
If it's worth to have one more reviewer, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 

-- 
Carlos
