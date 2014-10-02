From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 02/12] gfs2: Set allowed quota types
Date: Thu, 02 Oct 2014 11:41:27 +0100
Message-ID: <542D2BD7.8020704@redhat.com>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
        Dave Chinner <david@fromorbit.com>, reiserfs-devel@vger.kernel.org,
        xfs@oss.sgi.com, cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1412191894-9113-3-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

On 01/10/14 20:31, Jan Kara wrote:
> We support user and group quotas. Tell vfs about it.
>
> CC: Steven Whitehouse <swhiteho@redhat.com>
> CC: cluster-devel@redhat.com
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   fs/gfs2/ops_fstype.c | 1 +
>   1 file changed, 1 insertion(+)
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index d3eae244076e..3032e6d069b5 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -1083,6 +1083,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
>   	sb->s_xattr = gfs2_xattr_handlers;
>   	sb->s_qcop = &gfs2_quotactl_ops;
>   	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
> +	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
>   	sb->s_time_gran = 1;
>   	sb->s_maxbytes = MAX_LFS_FILESIZE;
>   
