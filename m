From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: reserving code points for new ext4 quota feature
Date: Tue, 15 Feb 2011 13:45:27 -0700
Message-ID: <745DB43F-B3C1-4730-8F29-38F734988617@dilger.ca>
References: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com> <BD2A37BD-B970-4520-A8AB-589249C96755@dilger.ca> <20110215170713.GF4255@thunk.org> <AANLkTimsXW82EgB5Fq2Bwc77RYny_DmSPWwgHvQmNKPM@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44691 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1BOUpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Feb 2011 15:45:32 -0500
In-Reply-To: <AANLkTimsXW82EgB5Fq2Bwc77RYny_DmSPWwgHvQmNKPM@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-15, at 12:54, Aditya Kali wrote:
> This patch adds support for detecting the new 'quota' feature in ext4.
> The patch reserves code points for usr and group quota inodes and also
> for the feature flag EXT4_FEATURE_RO_COMPAT_QUOTA.
> 
> diff --git a/ext2ed/inode_com.c b/ext2ed/inode_com.c
> index 843286c..cf7083d 100644
> --- a/ext2ed/inode_com.c
> +++ b/ext2ed/inode_com.c
> @@ -222,12 +222,6 @@ void type_ext2_inode___show (char *command_line)
> 			case EXT2_ROOT_INO:
> 				wprintw (show_win,"Root inode - ");
> 				break;
> -			case EXT2_ACL_IDX_INO:
> -				wprintw (show_win,"ACL index inode - ");
> -				break;
> -			case EXT2_ACL_DATA_INO:
> -				wprintw (show_win,"ACL data inode - ");
> -				break;

Most of the patch looks OK, though I don't understand why these are removed, instead of replacing them with EXT2_GRP_QUOTA_INO and EXT2_USR_QUOTA_INO?

Cheers, Andreas





