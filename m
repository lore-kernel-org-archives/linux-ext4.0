From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] fs: Add MODULE_SOFTDEP declarations for hard-coded
 crypto drivers
Date: Tue, 17 May 2016 16:59:47 +0200
Message-ID: <20160517145947.GT511@twin.jikos.cz>
References: <20160517133631.GF7555@decadent.org.uk>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160517133631.GF7555@decadent.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 17, 2016 at 02:36:31PM +0100, Ben Hutchings wrote:
> This helps initramfs builders and other tools to find the full
> dependencies of a module.
> 
> References: https://bugs.debian.org/819725
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2456,3 +2456,4 @@ late_initcall(init_btrfs_fs);
>  module_exit(exit_btrfs_fs)
>  
>  MODULE_LICENSE("GPL");
> +MODULE_SOFTDEP("pre: crypto-crc32c");

Acked-by: David Sterba <dsterba@suse.com>
