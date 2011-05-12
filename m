From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Thu, 12 May 2011 18:55:42 +0300
Message-ID: <1305215742.27848.40.camel@jaguar>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
	 <1305213359.2575.46.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121024350.26013@router.home>
	 <1305214993.2575.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Colin King <colin.king@canonical.com>,
 Raghavendra D Prabhu <raghu.prabhu13@gmail.com>, Jan Kara <jack@suse.cz>,
 Chris Mason <chris.mason@oracle.com>, Rik van Riel <riel@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, linux-ext4
 <linux-ext4@vger.kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1305214993.2575.50.camel@mulgrave.site>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2011-05-12 at 10:43 -0500, James Bottomley wrote:
> However, since you admit even you see problems, let's concentrate on
> fixing them rather than recriminations?

Yes, please. So does dropping max_order to 1 help?
PAGE_ALLOC_COSTLY_ORDER is set to 3 in 2.6.39-rc7.

			Pekka

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
