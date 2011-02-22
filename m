From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 0/4] EXT4 trim bug fixes and improvement.
Date: Tue, 22 Feb 2011 21:11:25 +0800
Message-ID: <4D63B5FD.2010701@tao.ma>
References: <4D522B9B.5070707@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:53600 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751697Ab1BVNMM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 08:12:12 -0500
In-Reply-To: <4D522B9B.5070707@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
     any comments for this patch set? Are there ready for the next merge 
window?
     The most complicate patch [4/4] has already reviewed by Andreas.

Regards,
Tao
On 02/09/2011 01:52 PM, Tao Ma wrote:
> Hi Ted and the list,
>     Here are 4 patches for trim support in ext4.
>     Patch 1/4 is a fix for the 'len' overflow. As we have decided that 
> we don't adjust start to s_first_data_block, this patch is still needed.
>     Patch 2/4 is a speedup for trim in one group.
>     Patch 3/4 adds trace points for the functions used in FITRIM.
>     Patch 4/4 is a speedup for trim in the whole volume. For more 
> details, please check the commit log.
>
> Regards,
> Tao
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

