From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH 4/4 v3] XFS TESTS: Fix 252 Failure: Add Generic FS
 Punch Hole Test 255
Date: Wed, 13 Jul 2011 11:31:56 -0500
Message-ID: <1310574716.1998.25.camel@doink>
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
	 <1309411441-2491-5-git-send-email-achender@linux.vnet.ibm.com>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<xfs@oss.sgi.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:47898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754596Ab1GMQcC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jul 2011 12:32:02 -0400
In-Reply-To: <1309411441-2491-5-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-06-29 at 22:24 -0700, Allison Henderson wrote:
> This patch adds a new test 255 that tests fallocate punch hole,
> but is for use by generic filesystems.  It is similar to 252,
> but uses a weaker fiemap filter that only displays the location
> of the hole, and not the extent types.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

I realize Christoph already committed this but I
spotted something so I thought I might as well
mention it.  I haven't tested any of this, so
it may be OK after all, but if it's not then
the filter_hole_fiemap() function ought to be
updated.

					-Alex

. . .

> diff --git a/common.punch b/common.punch
> index c18f88a..a48b7ae 100644
> --- a/common.punch
> +++ b/common.punch
> @@ -218,6 +218,23 @@ _filter_fiemap()
>  	_coalesce_extents
>  }
>  
> +# Filters fiemap output to only print the 
> +# file offset column and whether or not
> +# it is an extent or a hole
> +_filter_hole_fiemap()
> +{
> +	awk --posix '
> +		$3 ~ /hole/ {
> +			print $1, $2, $3; 
> +			next;
> +		}   
> +		$5 ~ /0x[[:digit:]]+/ {

I believe this should be:
                 $5 ~ /0x[[:xdigit:]]+/ {

(I.e., hex digits, not just decimals.)

> +			print $1, $2, "extent";
> +		}' |
> +	_coalesce_extents
> +}
> +
> +
>  # Prints the md5 checksum of a given file
>  _md5_checksum()
>  {

. . .

