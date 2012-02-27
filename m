From: Zach Brown <zab@zabbo.net>
Subject: Re: [RFC PATCH 18/22] ext3: add support for .read_iter and .write_iter
Date: Mon, 27 Feb 2012 17:34:22 -0500
Message-ID: <4F4C04EE.7080306@zabbo.net>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <1330377576-3659-19-git-send-email-dave.kleikamp@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330377576-3659-19-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>   drivers/block/loop.c |   55 ++++++++++++++++++-
>   fs/ext3/file.c       |    2 +
>   fs/ext3/inode.c      |  149 ++++++++++++++++++++++++++++++++++----------------
>   include/linux/loop.h |    1 +
>   4 files changed, 160 insertions(+), 47 deletions(-)

It looks like the patch that teaches loop to use the kernel aio
interface got combined with the patch that adds the _bvec entry points
to ext3.

> +	if (file->f_op->write_iter&&  file->f_op->read_iter) {
> +		file->f_flags |= O_DIRECT;
> +		lo_flags |= LO_FLAGS_USE_AIO;
> +	}

This manual setting of f_flags still looks very fishy to me.  I remember
finding that pattern somewhere else but that's not very comforting :).

- z
