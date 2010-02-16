From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mk2fs lazy_journal_init option
Date: Tue, 16 Feb 2010 17:21:32 -0600
Message-ID: <4B7B287C.2030105@redhat.com>
References: <13A447AA-31C7-4E02-8752-DFF75EA31C2E@sun.com> <7095A240-FB57-4C33-8EE8-33D88B500319@sun.com> <4B7B2619.8060106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <ihara@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933279Ab0BPXVh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 18:21:37 -0500
In-Reply-To: <4B7B2619.8060106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> Haven't dug all the way through it but I think this is another
> in the saga of blk_t vs. blk64_t.  This seems to fix (?) it:
> 
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -218,7 +218,7 @@ struct mkjournal_struct {
>  };
> 
>  static int mkjournal_proc(ext2_filsys  fs,
> -                          blk_t        *blocknr,
> +                          blk64_t      *blocknr,
>                            e2_blkcnt_t  blockcnt,
>                            blk_t        ref_block EXT2FS_ATTR((unused)),
>                            int          ref_offset EXT2FS_ATTR((unused)),
> 
> though I doubt that is correct/complete.

Humm my git tree is not what I thought it was, the above might be a
wild goose chase, sorry.

-Eric
