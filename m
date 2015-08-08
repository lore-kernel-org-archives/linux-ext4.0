From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH 13/19] tune2fs: Add support for changing number of reserved inodes
Date: Sat, 8 Aug 2015 10:45:00 +0300
Message-ID: <9A74D391-E8E3-42A1-9319-5A0B54BDBC5F@gmail.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com> <1438944689-24562-14-git-send-email-jack@suse.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33438 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbHHHpG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2015 03:45:06 -0400
Received: by lbbyj8 with SMTP id yj8so71861430lbb.0
        for <linux-ext4@vger.kernel.org>; Sat, 08 Aug 2015 00:45:03 -0700 (PDT)
In-Reply-To: <1438944689-24562-14-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Aug 7, 2015, at 1:51 PM, Jan Kara <jack@suse.com> wrote:
> 
> Signed-off-by: Jan Kara <jack@suse.com>
> ---
> 
> +			new_first_ino = strtoul(arg, &p, 0);
> +			if (*p) {
> +				fprintf(stderr,
> +					_("Invalid number of reserved inodes "
> +					  "%s\n"),
> +					arg);
> +				r_usage++;
> +				continue;
> +			}
> 

this check invalid - you need check an errno for ERANGE also. 
add check against maximal number inodes on FS is also good.
