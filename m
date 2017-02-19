From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 1/5] vfs: Add file timestamp range support
Date: Sun, 19 Feb 2017 01:56:43 +0000
Message-ID: <20170219015638.GG29622@ZenIV.linux.org.uk>
References: <1487460608-15697-1-git-send-email-deepa.kernel@gmail.com>
 <1487460608-15697-2-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487460608-15697-2-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 18, 2017 at 03:30:04PM -0800, Deepa Dinamani wrote:
> Add fields to the superblock to track the min and max
> timestamps supported by filesystems.
> 
> Initially, when a superblock is allocated, initialize
> it to the max and min values the fields can hold.
> Individual filesystems override these to match their
> actual limits.
> 
> Pseudo filesystems are assumed to always support the
> min and max allowable values for the fields.

> @@ -257,6 +257,8 @@ struct dentry *mount_pseudo_xattr(struct file_system_type *fs_type, char *name,
> +	s->s_time_min = TIME64_MIN;
> +	s->s_time_max = TIME64_MAX;
> @@ -518,6 +520,8 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
> +	s->s_time_min = TIME64_MIN;
> +	s->s_time_max = TIME64_MAX;
> @@ -247,6 +247,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
> +	s->s_time_min = TIME64_MIN;
> +	s->s_time_max = TIME64_MAX;

If we always initialize them that way, why does libfs.c code bother
reassign the same values?
