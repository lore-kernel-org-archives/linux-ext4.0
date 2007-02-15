From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 12:56:54 -0800
Message-ID: <20070215125654.b0f18ab3.akpm@linux-foundation.org>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com>
	<m3k5yj49bw.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161250AbXBOU5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 15:57:37 -0500
In-Reply-To: <m3k5yj49bw.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 15 Feb 2007 20:30:43 +0300 Alex Tomas <alex@clusterfs.com> wrote:

> >>>>> Eric Sandeen (ES) writes:
> 
>  ES> Andrew Morton wrote:
>  >> Sorry, we're seriously, seriously, seriously short on flags in the page
>  >> struct and this patch is going to need one heck of a good case for it to be
>  >> acceptable.
> 
>  ES> This was for the delayed allocation patchset, right; and by managing
>  ES> this at the page level that means we can't do this for block size <
>  ES> page size, I think...
> 
> I still think that having PG_booked and special code to handle
> case when blocksize==pagesize is worthwhile -- we save 56 bytes
> on 32bit and 104 bytes on 64bit for every written page.
> 

If the page doesn't have buffer-heads, set PG_private and clear page->private

If the page does have buffer_heads, use BH_Delay.
