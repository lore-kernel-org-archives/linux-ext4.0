From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 2/2] ext4: MMP: fix error message rate-limiting logic in kmmpd
Date: Fri, 23 Sep 2011 12:51:54 -0600
Message-ID: <D264B6D0-DA9C-44EB-A7DD-E2A20DC3A631@dilger.ca>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com> <1316737389-5522-3-git-send-email-nikitas_angelinas@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Johann Lombardi <johann@whamcloud.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel Kernel <linux-kernel@vger.kernel.org>,
	Nikitas Angelinas <nikitas_angelinas@xyratex.com>,
	andrew_perepechko@xyratex.com
To: Theodore Tso <tytso@mit.edu>,
	Nikitas Angelinas <nikitasangelinas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:40598 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1IWSvz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 14:51:55 -0400
In-Reply-To: <1316737389-5522-3-git-send-email-nikitas_angelinas@xyratex.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-22, at 6:23 PM, Nikitas Angelinas wrote:
> Current logic would print an error message only once, and then
> 'failed_writes' would stay at 1. Rework the loop to increment
> 'failed_writes' and print the error message every s_mmp_update_interval
> * 60 seconds, as intended according to the comment.
> 
> Perhaps it would be better to reset 'failed_writes' to 0 on every
> successful write, such that new errors are noticed sooner, but maybe in
> the interest of efficiency it would be best not to add an operation on
> every kmmpd thread run?
> 
> Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
> Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>

Acked-by: Andreas Dilger <adilger@dilger.ca>

Thanks for the fix.
> ---
> fs/ext4/mmp.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 2fca64e..6b32742 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -125,8 +125,9 @@ static int kmmpd(void *data)
> 		 * Don't spew too many error messages. Print one every
> 		 * (s_mmp_update_interval * 60) seconds.
> 		 */
> -		if (retval && (failed_writes % 60) == 0) {
> -			ext4_error(sb, "Error writing to MMP block");
> +		if (retval) {
> +			if ((failed_writes % 60) == 0)
> +				ext4_error(sb, "Error writing to MMP block");
> 			failed_writes++;
> 		}
> 
> -- 
> 1.7.4.4
> 


Cheers, Andreas





