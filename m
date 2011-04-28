From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
Date: Thu, 28 Apr 2011 10:57:42 -0500
Message-ID: <1304006262.2598.2.camel@mulgrave.site>
References: <1303920553.2583.7.camel@mulgrave.site>
	 <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site>
	 <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site>
	 <1303925374-sup-7968@think>  <1303926637.2583.17.camel@mulgrave.site>
	 <1303928753.2417.6.camel@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, linux-ext4
 <linux-ext4@vger.kernel.org>
To: Colin Ian King <colin.king@ubuntu.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1303928753.2417.6.camel@lenovo>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2011-04-27 at 19:25 +0100, Colin Ian King wrote:
> Just like to add that I've seen almost identical issues with 2.6.38
> copying large amounts of data to an ext4 filesystem with systems with
> small amounts of memory.
> 
> I found that increasing /sys/fs/ext4/sdaX/max_writeback_mb_bump worked
> around the issue.

With the PREEMPT kernel, values of 256 and 512 don't prevent kswapd
spinning up to 99% and staying there.

James


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
