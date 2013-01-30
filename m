From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 5/6] ocfs2: Wait for page writeback to provide stable
 pages
Date: Tue, 29 Jan 2013 17:03:57 -0800
Message-ID: <20130130010356.GL26439@localhost>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
 <20130119011308.20902.44871.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de,
	Mark Fasheh <mfasheh@suse.com>, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, ocfs2-devel@oss.oracle.com,
	bharrosh@panasas.com, jlayton@samba.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130119011308.20902.44871.stgit@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Acked-by: Joel Becker <jlbec@evilplan.org>

On Fri, Jan 18, 2013 at 05:13:08PM -0800, Darrick J. Wong wrote:
> When stable pages are required, we have to wait if the page is just
> going to disk and we want to modify it. Add proper callback to
> ocfs2_grab_pages_for_write().
> 
> CC: ocfs2-devel@oss.oracle.com
> CC: Joel Becker <jlbec@evilplan.org>
> CC: Mark Fasheh <mfasheh@suse.com>
> From: Jan Kara <jack@suse.cz>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ocfs2/aops.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 6577432..9796330 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1194,6 +1194,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  				goto out;
>  			}
>  		}
> +		wait_for_stable_page(wc->w_pages[i]);
>  
>  		if (index == target_index)
>  			wc->w_target_page = wc->w_pages[i];
> 

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

			http://www.jlbec.org/
			jlbec@evilplan.org
