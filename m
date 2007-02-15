From: Alex Tomas <alex@clusterfs.com>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 20:30:43 +0300
Message-ID: <m3k5yj49bw.fsf@bzzz.home.net>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Alex Tomas <alex@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.245.246] ([80.71.245.246]:63838 "EHLO nsold.rialcom.ru"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161321AbXBOVLV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 16:11:21 -0500
In-Reply-To: <45D495EA.3060200@redhat.com> (Eric Sandeen's message of "Thu\, 15
	Feb 2007 09\:18\:34 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Eric Sandeen (ES) writes:

 ES> Andrew Morton wrote:
 >> Sorry, we're seriously, seriously, seriously short on flags in the page
 >> struct and this patch is going to need one heck of a good case for it to be
 >> acceptable.

 ES> This was for the delayed allocation patchset, right; and by managing
 ES> this at the page level that means we can't do this for block size <
 ES> page size, I think...

I still think that having PG_booked and special code to handle
case when blocksize==pagesize is worthwhile -- we save 56 bytes
on 32bit and 104 bytes on 64bit for every written page.

thanks, Alex
