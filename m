From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2] ext4: fix shared/002 and 004 teacase fail issue in xfstests
Date: Wed, 9 Apr 2014 19:46:28 +0900
Message-ID: <CAKYAXd_g0J2MkF1F868=S0MBrtk-oCC4vw9h4tg3LCU80yTEfw@mail.gmail.com>
References: <001301cf53dd$cf23c720$6d6b5560$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33873 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDIKq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 06:46:29 -0400
Received: by mail-qa0-f45.google.com with SMTP id cm18so1523018qab.4
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2014 03:46:29 -0700 (PDT)
In-Reply-To: <001301cf53dd$cf23c720$6d6b5560$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

plz ignore this patch. I will send it again.
Thanks.

2014-04-09 19:23 GMT+09:00, Namjae Jeon <namjae.jeon@samsung.com>:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> When mounting ext4 with data=journal option, xfstest shared/002 and
> shared/004
> are currently failing as checksum computed for testfile does not match with
> the checksum computed in other journal modes. In case of data=journal mode,
> a call to filemap_write_and_wait_range will not flush anything to disk as
> buffers are not marked dirty in write_end. In collapse range this call is
> followed by a call to truncate_pagecache_range. Due to this, when checksum
> is
> computed, a portion of file is re-read from disk which replace valid data
> with
> NULL bytes and hence the reason for the difference in checksum.
>
> Calling ext4_force_commit before filemap_write_and_wait_range solves the
> issue
> as it will mark the buffers dirty during commit transaction which can be
> later
> synced by a call to filemap_write_and_wait_range.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/extents.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d7a78ed..ec1d9c4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5112,6 +5112,13 @@ int ext4_collapse_range(struct inode *inode, loff_t
> offset, loff_t len)
>  	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
>  	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
>
> +	/* Call ext4_force_commit to flush all data in case of
> data=journal.*/
> +	if (ext4_should_journal_data(inode)) {
> +		ret = ext4_force_commit(inode->i_sb);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* Write out all dirty pages */
>  	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
>  	if (ret)
> --
> 1.7.11-rc0
>
>
