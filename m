From: Adrian Bunk <bunk@kernel.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 11:11:46 +0300
Message-ID: <20080619081146.GC17630@cs181133002.pp.htv.fi>
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60778 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbYFSINV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 04:13:21 -0400
Content-Disposition: inline
In-Reply-To: <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 19, 2008 at 03:42:34PM +1000, Dave Airlie wrote:
> On Thu, Jun 19, 2008 at 3:36 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> > In the kerneloops.org stats, a new oops is rapidly climbing the charts.
> > The oops is a page fault in the ext3 "do_slit" function, and the first
> > report of it was with 2.6.26-rc6-git3.
> >
> > It happens with various applications; the backtraces are at:
> >
> > http://www.kerneloops.org/search.php?search=do_split
> 
> This is a bug in rawhide in gcc miscompiling something...
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=451068

If I understand it correctly that's a bug in upstream gcc 4.3.1
(but not in gcc 4.3.0)?

Expect a lot more of this to pop up in the future.
Should we #error for gcc 4.3.1?

> Dave.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

