Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335A4C10F0E
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 23:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBCAE20840
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 23:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfDGX6q (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 19:58:46 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59385 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726223AbfDGX6q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 19:58:46 -0400
Received: from callcc.thunk.org (90.sub-174-222-3.myvzw.com [174.222.3.90])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x37Nwb7p032034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 7 Apr 2019 19:58:39 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 37440421A0D; Sun,  7 Apr 2019 19:58:36 -0400 (EDT)
Date:   Sun, 7 Apr 2019 19:58:36 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     harshadshirwadkar@gmail.com
Cc:     linux-ext4@vger.kernel.org, adilger@dilger.ca
Subject: Re: [PATCH v3] ext4: shrink directory when last block is empty
Message-ID: <20190407235836.GA29128@mit.edu>
References: <20190227040118.246464-1-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227040118.246464-1-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 26, 2019 at 08:01:18PM -0800, harshadshirwadkar@gmail.com wrote:
>
+static bool
+ext4_dx_delete_entry(handle_t *handle, struct inode *dir,
+		     struct dx_frame *dx_frame, __le64 block)
+{
>

The function name is a bit problematic.  The ext4_find_entry,
ext4_dx_find_entry, ext4_delete_entry() all operate on the directory
entry.  This is doing something different --- it's operating to remove
the hash tree dx entry.  So something maybe like
ext4_remove_dx_entry()?  And we definitely need some documentation for
this function.

Also, I think we can drop last argument, since you can get it from
 cpu_to_le64(dx_get_block(dx_frame->at)).

> +
> +static inline bool should_try_dx_delete(struct dx_frame *dx_frame,
> +					struct buffer_head *bh,
> +					struct inode *dir)
> +{
> +	return dx_frame && dx_frame->bh && is_empty_dirent_block(dir, bh) &&
> +			dx_get_block(dx_frame->at) ==
> +			(dir->i_size - 1) >> dir->i_sb->s_blocksize_bits;
> +}

As above, I'm not sure this is a great name for the function --- and
for that matter, I'm not sure it's worth it to separate this out.
First of all, we want to be able to truncate non-indexed directory,
not just indexed directories.  So moving this logic into
ext4_delete_entry() probably makes sense.

If the directory is not indexed, it's really trivial to truncate it
--- and the xfstests change you submitted would fail on file system
configurations if the dir_index feature is not set, so we should
really do that simple case while we're at it.


> -static struct buffer_head * ext4_find_entry (struct inode *dir,
> -					const struct qstr *d_name,
> -					struct ext4_dir_entry_2 **res_dir,
> -					int *inlined)
> +static struct buffer_head *ext4_find_entry(struct inode *dir,
> +					   const struct qstr *d_name,
> +					   struct ext4_dir_entry_2 **res_dir,
> +					   int *inlined,
> +					   struct dx_frame *dx_frame)

Could you add some documentation for this function --- specifically,
why a caller might want to pass in dx_frame, and what it's used for?

BTW, ext4_rmdir() should have also been modified to pass in dx_frame
when calling ext4_find_entry().  Right now with this patch, if the
last entry is a directory, when it's rmdir'ed, since ext4_rmdir()
doesn't have the plumbing to pass dx_frame to ext4_delete_entry(),
we'll end up leaving an empty directory entry on the directory entry.

Thanks,

      	     	     	      		- Ted
