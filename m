From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 09:00:45 -0500
Message-ID: <485A668D.3050306@redhat.com>
References: <4859F075.2050207@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYFSOBR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 10:01:17 -0400
In-Reply-To: <4859F075.2050207@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arjan van de Ven wrote:
> In the kerneloops.org stats, a new oops is rapidly climbing the charts.
> The oops is a page fault in the ext3 "do_slit" function, and the first
> report of it was with 2.6.26-rc6-git3.
> 
> It happens with various applications; the backtraces are at:
> 
> http://www.kerneloops.org/search.php?search=do_split

Arjan, I was just looking at kerneloops last night, seeing the count for
this oops climb, and was wishing there were some way to annotate an oops
signature with more info.  If I could have tagged this with the RH
bugzilla nr. it might have saved a lot of time for folks.  Is this
feasible?  Or is finding the oops text in bugzilla the only way?

Thanks,

-Eric

