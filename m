From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Fri, 13 May 2011 09:16:24 +0300
Message-ID: <BANLkTindTdL9a4VxZk_AXrWLQf6QWqjz5g@mail.gmail.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	<1305127773-10570-4-git-send-email-mgorman@suse.de>
	<alpine.DEB.2.00.1105120942050.24560@router.home>
	<1305213359.2575.46.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121024350.26013@router.home>
	<1305214993.2575.50.camel@mulgrave.site>
	<1305215742.27848.40.camel@jaguar>
	<1305225467.2575.66.camel@mulgrave.site>
	<1305229447.2575.71.camel@mulgrave.site>
	<1305230652.2575.72.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1EMGQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 02:16:25 -0400
In-Reply-To: <1305230652.2575.72.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, May 12, 2011 at 11:04 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Confirmed, I'm afraid ... I can trigger the problem with all three
> patches under PREEMPT. =A0It's not a hang this time, it's just kswapd
> taking 100% system time on 1 CPU and it won't calm down after I unloa=
d
> the system.

OK, that's good to know. I'd still like to take patches 1-2, though. Me=
l?

                        Pekka
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
