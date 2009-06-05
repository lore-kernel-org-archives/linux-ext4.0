From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Fri, 05 Jun 2009 03:25:22 -0400
Message-ID: <1244186723.11597.111.camel@localhost.localdomain>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	 <20090603115611.6bbbaf55.akpm@linux-foundation.org>
	 <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dallas.jonmasters.org ([72.29.103.172]:38350 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZFEO7b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 10:59:31 -0400
In-Reply-To: <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-06-04 at 14:53 +0200, Kay Sievers wrote:
> On Wed, Jun 3, 2009 at 20:56, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed,  3 Jun 2009 18:05:14 +0300 Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:
> 
> > hm, I'm uncertain on the desirability or otherwise of the
> > overall feature.

I think the idea is a good one. It allows a distribution to take more
proactive measures before services just start dying randomly later. I
could see this nicely wrapped up with some kind of GUI dialog presented
to the desktop user announcing impending doom, too.

> Uevents should not be used for error reporting

Not as currently implemented - but I think the idea of having kernel
events for this kind of thing isn't a bad one, nor is the idea of
listening on a netlink socket for news about them rather than writing
library code to poll whatever procfs file and parse its content.

Jon.


