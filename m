From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [PATCH 01/15][e2fsprogs] libext2fs: Add 64-bit support to the undo manager
Date: Wed, 16 Jul 2008 13:16:58 +0200
Message-ID: <873ama2i51.fsf@frosties.localdomain>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165008.28567.22096.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53753 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYGPLSZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 07:18:25 -0400
In-Reply-To: <20080715165008.28567.22096.stgit@ichigo> (Jose R. Santos's
	message of "Tue, 15 Jul 2008 11:50:08 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> From: Jose R. Santos <jrs@us.ibm.com>
>
> libext2fs: Add 64-bit support to the undo manager
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> --
>
>  lib/ext2fs/undo_io.c |   55 +++++++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 45 insertions(+), 10 deletions(-)
>
> diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
> index 827c038..7661b83 100644
> --- a/lib/ext2fs/undo_io.c
> +++ b/lib/ext2fs/undo_io.c
> @@ -73,6 +73,10 @@ struct undo_private_data {
>  static errcode_t undo_open(const char *name, int flags, io_channel *channel);
>  static errcode_t undo_close(io_channel channel);
>  static errcode_t undo_set_blksize(io_channel channel, int blksize);
> +static errcode_t undo_read_blk64(io_channel channel, unsigned long long block,
> +				 int count, void *data);

Why not this?

+static errcode_t undo_read_blk64(io_channel channel, blk64_t block,
+				 int count, void *data);

libext2fs specifically has blk_t and blk64_t types to represent a
block. Why not use them? It is less to type and easier to read.

MfG
        Goswin
