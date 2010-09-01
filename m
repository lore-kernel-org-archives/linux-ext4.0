From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [patch] e4defrag: relevant file fragmentation with base_file
Date: Wed, 01 Sep 2010 17:30:13 +0900
Message-ID: <4C7E0F15.40007@sx.jp.nec.com>
References: <4C7AB958.4080101@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Andreas Rid <andreas@rid-net.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45613 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0IAIch (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Sep 2010 04:32:37 -0400
In-Reply-To: <4C7AB958.4080101@rid-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/08/30 4:47, Andreas Rid wrote:
> @@ -2327,8 +2320,44 @@ int main(int argc, char *argv[])
>   			} else
>   				printf("ext4 defragmentation for %s\n",
>   								 argv[i]);
> -			/* Defrag single file process */
> -			file_defrag(argv[i],&buf, FTW_F, NULL);
> +
> +			if (mode_flag&  RELEVANT&&  i == optind) {
> +				if (i - argc == 1)
> +					/* not enought arguemnts */
> +					goto out;

I think this condition should be "argc - optind == 1" because "i" is smaller
than argc at all times.

> +					goto out;
> +				}
> +				
> +				r_pstart = get_physical_offset(fd,&ret);

If e4defrag is executed with the following arguments, e4defrag will move the
extents of "move_file" near the "directory".
# e4defrag -r base_file directory move_file

To prevent this case, r_pstart should not be changed even if directories or
devices are set to the argument of e4defrag after the physical block number of
the "base_file" was assigned to r_pstart.

I will fix your patch in above way. Any comments?

Regards,
Kazuya Mio

