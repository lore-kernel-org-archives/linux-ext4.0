From: steve@chygwyn.com
Subject: Re: [PATCH 6/10] gfs2: Fix error handling in
	write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 12:23:45 +0100
Message-ID: <20080922112345.GA10387@fogou.chygwyn.com>
References: <20080922195718t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752675AbYIVLZ5@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080922195718t-sato@mail.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Mon, Sep 22, 2008 at 07:57:18PM +0900, Takashi Sato wrote:
> I've changed write_super_lockfs/unlockfs so that they always return
> 0 (success) to keep a current behavior.
> 
> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
> ---
>  ops_super.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c linux
> -2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
> --- linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c	2008-09-22 07:29:55.000000000 +0900
> +++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-22 10:52:16.000000000 +0900
> @@ -166,13 +166,13 @@ static int gfs2_sync_fs(struct super_blo
>   *
>   */
>  
> -static void gfs2_write_super_lockfs(struct super_block *sb)
> +static int gfs2_write_super_lockfs(struct super_block *sb)
>  {
>  	struct gfs2_sbd *sdp = sb->s_fs_info;
>  	int error;
>  
>  	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
> -		return;
> +		return 0;
>
Since this now returns a status, then this should indicate a failure
I think. Perhaps -EINVAL would be suitable?

Otherwise it looks good from a gfs2 perspective,

Steve.
