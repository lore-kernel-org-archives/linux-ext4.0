From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: fix configuration dependencies for ext4 ACLs and
 security labels
Date: Sun, 06 Jan 2013 13:17:46 +0800
Message-ID: <50E908FA.2030001@tao.ma>
References: <1357444389-4895-1-git-send-email-val@vaaconsulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	David Brown <davidb@codeaurora.org>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Tao Ma <boyu.mt@taobao.com>
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57689 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750734Ab3AFFY3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jan 2013 00:24:29 -0500
In-Reply-To: <1357444389-4895-1-git-send-email-val@vaaconsulting.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/06/2013 11:53 AM, Valerie Aurora wrote:
> Commit "ext4: Remove CONFIG_EXT4_FS_XATTR" removed the configuration
> dependencies for ext4 xattrs from the ext4 ACLs and security labels
> configuration options, but did not replace them with a dependency on
> ext4 itself.  Add back the dependency on ext4 so the options only show
> up if ext4 is enabled.
> 
> Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Thanks.
Acked-by: Tao Ma <boyu.mt@taobao.com>

> ---
>  fs/ext4/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index 0a475c8..9873587 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -41,6 +41,7 @@ config EXT4_USE_FOR_EXT23
>  
>  config EXT4_FS_POSIX_ACL
>  	bool "Ext4 POSIX Access Control Lists"
> +	depends on EXT4_FS
>  	select FS_POSIX_ACL
>  	help
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
> @@ -53,6 +54,7 @@ config EXT4_FS_POSIX_ACL
>  
>  config EXT4_FS_SECURITY
>  	bool "Ext4 Security Labels"
> +	depends on EXT4_FS
>  	help
>  	  Security labels support alternative access control models
>  	  implemented by security modules like SELinux.  This option
> 

