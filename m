From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/2] e2fsprogs: fix data lost with mke2fs -S
Date: Mon, 27 Feb 2012 15:26:03 +0900
Message-ID: <4F4B21FB.5060705@rs.jp.nec.com>
References: <4EF2EA9E.9080500@rs.jp.nec.com> <20120217042038.GA9319@thunk.org> <4F434328.2000409@rs.jp.nec.com> <20120227055435.GC9881@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45085 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2B0G00 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 01:26:26 -0500
In-Reply-To: <20120227055435.GC9881@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(2012/02/27 14:54), Ted Ts'o wrote:
> On Tue, Feb 21, 2012 at 04:09:28PM +0900, Akira Fujita wrote:
>>
>> I tried to mkfs -S and e2fsck to salvage file
>> with e2fsprogs 1.42.1 (commit: 5ab348723247).
>> But it seemed that the file was removed after e2fsck.
> 
> Oops, sorry.  I made a stupid mistake in my mke2fs patch.  This should
> fix things so that your script works correctly.

Worked fine, thank you for you work. :)

Akira Fujita
 
> 					- Ted
> 
> commit 30ac1ce7df719e40b0c3c612696ada7c9ebbaed2
> Author: Theodore Ts'o<tytso@mit.edu>
> Date:   Mon Feb 27 00:51:39 2012 -0500
> 
>      mke2fs: make sure bg 0's unused inode count field is zero'ed for mke2fs -S
> 
>      There was a bug/typo in commit ba9e0afc5 which caused the first block
>      group (bg #0) to not have its unused inode count field to get set to
>      zero in the case of mke2fs -S.  This caused inodes in the first block
>      group to not be recoverable via mke2fs -S.  Oops.
> 
>      Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index c70c1b4..51435d2 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2442,7 +2442,7 @@ int main (int argc, char *argv[])
>   		 */
>   		if (fs->super->s_feature_ro_compat&
>   		EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
> -			for (i = 1; i<  fs->group_desc_count; i++)
> +			for (i = 0; i<  fs->group_desc_count; i++)
>   				ext2fs_bg_itable_unused_set(fs, i, 0);
>   		}
>   	} else {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
