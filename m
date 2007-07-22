From: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Mon, 23 Jul 2007 00:52:22 +0200
Message-ID: <200707230052.23972.ioe-lkml@rameria.de>
References: <1183275498.4010.135.camel@localhost.localdomain> <20070713095343.d2e76775.akpm@linux-foundation.org> <1184665789.7063.8.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1184665789.7063.8.camel@garfield.linsyssoft.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 17 July 2007, Kalpak Shah wrote:
> Index: linux-2.6.22/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/ext4_fs.h
> +++ linux-2.6.22/include/linux/ext4_fs.h
> @@ -797,12 +797,18 @@ struct ext4_dir_entry_2 {
>    #define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
>                                               EXT4_FEATURE_COMPAT_DIR_INDEX) && \
>                       (EXT4_I(dir)->i_flags & EXT4_INDEX_FL))
> -#define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
> -#define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
> +static inline int ext4_dir_link_max(struct inode *dir)
> +{
> +       return (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX);
> +}
> +static inline int ext4_dir_link_empty(struct inode *dir)
> +{
> +       return ((dir)->i_nlink == 2 || (dir)->i_nlink == 1);
> +}

even better:

static inline bool ext4_is_dx(const struct inode *dir)
{
#ifdef FOOBAR
	return EXT4_HAS_COMPAT_FEATURE(dir->i_sb,   EXT4_FEATURE_COMPAT_DIR_INDEX) 
                   && (EXT4_I(dir)->i_flags & EXT4_INDEX_FL));
#else
	return false;
#endif
}

static inline bool ext4_dir_link_max(const struct inode *dir)
{
	return !ext4_is_dx(dir) && (dir->i_nlink >= EXT4_LINK_MAX);
}

static inline bool ext4_dir_link_empty(const struct inode *dir)
{
#ifdef FOOBAR
	return dir->i_nlink == 2 || dir->i_nlink == 1;
#else
	return dir->i_nlink == 2;
#endif
}


FOOBAR is the define, which enables ext4_is_dx(). 
That is not in the patch, so left as an exercise to the reader :-)

Best Regards

Ingo Oeser
