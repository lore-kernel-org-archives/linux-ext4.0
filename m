From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] quota: autoload the quota_v2 module for
 QFMT_VFS_V1 quota format
Date: Mon, 21 Jan 2013 11:40:17 +0100
Message-ID: <20130121104017.GD5588@quack.suse.cz>
References: <20130121054741.GB321@thunk.org>
 <1358750781-5670-1-git-send-email-tytso@mit.edu>
 <1358750781-5670-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358750781-5670-2-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 21-01-13 01:46:21, Ted Tso wrote:
> Otherwise, ext4 file systems with the quota feature enable will get a
> very confusing "No such process" error message if the quota code is
> built as a mdoule and the quota_v2 module has not been loaded.
  Thanks for the fix. Should I merge it via my tree or do you plan to do it
via your tree?

								Honza
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> ---
>  include/linux/quota.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 58fdef12..d133711 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -405,6 +405,7 @@ struct quota_module_name {
>  #define INIT_QUOTA_MODULE_NAMES {\
>  	{QFMT_VFS_OLD, "quota_v1"},\
>  	{QFMT_VFS_V0, "quota_v2"},\
> +	{QFMT_VFS_V1, "quota_v2"},\
>  	{0, NULL}}
>  
>  #endif /* _QUOTA_ */
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
