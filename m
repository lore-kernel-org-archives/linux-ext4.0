From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RESEND][PATCH 0/3 BUG,RFC] release block-device-mapping	buffer_heads
 which have the filesystem private data for avoiding	oom-killer
Date: Tue, 25 Nov 2008 17:06:54 +0900
Message-ID: <492BB21E.5000502@jp.fujitsu.com>
References: <20081120092711.231c69bf.toshi.okajima@jp.fujitsu.com> <20081125073224.GI20928@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37771 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYKYIHE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 03:07:04 -0500
In-Reply-To: <20081125073224.GI20928@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted-san,
Thanks for your applying.

Theodore Tso wrote:
> Okajima-san,
> 
> I've added your patches to the ext4 patch queue for testing.  I did
> make some changes to the commit descriptions for clarity's sake
> 
> -------------------------
> vfs: add releasepages hooks to block devices which can be used by file systems
<SNIP>
> -------------------------
> ext3: provide function to release journal heads under memory pressure
<SNIP>
> -------------------------
> ext4: implement release_metadata to release private data under memory pressure
<SNIP>
> ----------------------
> 
> Also, in the 2nd and 3rd patches, I made change to the comment
> describing ext[34]_release_metadata.  It now reads:
> 
> /*
>  * Try to release metadata pages (indirect blocks, directories) which are
>  * mapped via the block device.  Since these pages could have journal heads
>  * which would prevent try_to_free_buffers() from freeing them, we must use
>  * jbd[2] layer's try_to_free_buffers() function to release them.
>  */
> 
> I hope you agree these changes are more descriptive of what is going
> on in the patch.
OK!

I agree to your all appropriate changes.

(I am looking forward to merging them to mainstream kernel early. :-))

Best regards,
Toshiyuki Okajima

