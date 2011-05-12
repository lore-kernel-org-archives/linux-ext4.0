From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Thu, 12 May 2011 20:06:27 +0300
Message-ID: <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	<1305127773-10570-4-git-send-email-mgorman@suse.de>
	<alpine.DEB.2.00.1105120942050.24560@router.home>
	<1305213359.2575.46.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121024350.26013@router.home>
	<1305214993.2575.50.camel@mulgrave.site>
	<20110512154649.GB4559@redhat.com>
	<1305216023.2575.54.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121121120.26013@router.home>
	<1305217843.2575.57.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Lameter <cl@linux.com>, Dave Jones <davej@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
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
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53409 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab1ELRG2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 13:06:28 -0400
In-Reply-To: <1305217843.2575.57.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 12, 2011 at 7:30 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> So suggest an alternative root cause and a test to expose it.

Is your .config available somewhere, btw?
