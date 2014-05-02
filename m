From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 06/37] debugfs: force logdump to display (old) journal
 contents
Date: Fri, 2 May 2014 13:49:37 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021346570.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231302.31890.45397.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbaEBLtn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 07:49:43 -0400
In-Reply-To: <20140501231302.31890.45397.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:13:02 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 06/37] debugfs: force logdump to display (old) journal
>     contents
> 
> If the user passes -a more than once to logdump, try to dump old log
> contents.  This can be used to try to track down journal problems even
> after recovery.

You need to update man page as well for this. Also I wonder what's
the behaviour if '-a' and '-b' or '-c' are specified simultaneously
and '-a' is specified multiple times ?

Thanks!
-Lukas

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debugfs/logdump.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/debugfs/logdump.c b/debugfs/logdump.c
> index 8b9dc5b..bf4bef5 100644
> --- a/debugfs/logdump.c
> +++ b/debugfs/logdump.c
> @@ -393,9 +393,13 @@ static void dump_journal(char *cmdname, FILE *out_file,
>  	fprintf(out_file, "Journal starts at block %u, transaction %u\n",
>  		blocknr, transaction);
>  
> -	if (!blocknr)
> +	if (!blocknr) {
>  		/* Empty journal, nothing to do. */
> -		return;
> +		if (dump_all < 2)
> +			return;
> +		else
> +			blocknr = 1;
> +	}
>  
>  	while (1) {
>  		retval = read_journal_block(cmdname, source,
> @@ -420,7 +424,8 @@ static void dump_journal(char *cmdname, FILE *out_file,
>  			fprintf (out_file, "Found sequence %u (not %u) at "
>  				 "block %u: end of journal.\n",
>  				 sequence, transaction, blocknr);
> -			return;
> +			if (dump_all < 2)
> +				return;
>  		}
>  
>  		if (dump_descriptors) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
