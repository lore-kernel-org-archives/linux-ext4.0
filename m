From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Remove VLAIS usage from JBD2 code
Date: Tue, 30 Oct 2012 12:13:07 -0700
Message-ID: <20121030191307.GC19576@blackbox.djwong.org>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
 <1351622404-18214-2-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Mark Charlebois <charlebm@gmail.com>
To: Behan Webster <behanw@converseincode.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:27709 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2J3TOj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 15:14:39 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9UJEXXi031210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 19:14:33 GMT
Content-Disposition: inline
In-Reply-To: <1351622404-18214-2-git-send-email-behanw@converseincode.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 02:40:04PM -0400, Behan Webster wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). Since ctx is always a 32-bit CRC, hard coding a size of 4
> bytes accomplishes the same thing without the use of VLAIS. This is the same
> technique already employed in fs/ext4/ext4.h
> 
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  include/linux/jbd2.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 3efc43f..efcbdfc 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1308,7 +1308,7 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
>  {
>  	struct {
>  		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
> +		char ctx[4];

I wonder if this code ought to have a defensive programming check such as
BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) > 4) here just in case
we ever decide to support a checksum function that is bigger than 32 bits?

At this stage of the game I doubt we'll be adding larger checksums to
ext4/jbd2, but I wouldn't want to rely on remembering this detail if we ever
do want to change it.  I guess we could hide the check behind CONFIG_JBD_DEBUG
if we're concerned about slowing down the hot path.

The same comment applies to Ted's patch ("ext4: remove dynamic array size in
ext4_chksum()") back in July.

<shrug> Otherwise,

Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
>  	} desc;
>  	int err;
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
