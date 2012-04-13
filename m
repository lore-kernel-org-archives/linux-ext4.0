From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 10:53:32 -0700
Message-ID: <1334339612.3796.2.camel@schen9-DESK>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
	 <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
	 <20120324031357.GA5690@tassilo.jf.intel.com>
	 <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
	 <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org>
	 <m2zkaiyzjl.fsf@firstfloor.org>
	 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>, Ted Ts'o <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2DMRxc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 13:53:32 -0400
In-Reply-To: <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2012-04-13 at 10:42 -0700, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 9:59 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Ping. This scalability problem is still in 3.4-rc* and causes
> > major slowdowns.
> 
> Do you have numbers?
> 

In a benchmark that does mmaped-read, there is a 28% speed up
after getting rid of the counters.

> > Can we please revert fix it or revert
> > 556b27abf73833923d5cd4be80006292e1b31662 before release.
> 
> That commit ID doesn't make any sense, and doesn't seem to have
> anything to do with any statistics counters that your email talks
> about. So regardless, you'd need to explain why that commit causes the
> problems you talk about, I'm not going to revert a random commit that
> doesn't even look what you describe.
> 
> Ted?
> 
>                 Linus


