From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 15:33:56 -0400
Message-ID: <20120413193356.GB5898@thunk.org>
References: <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com>
 <20120326235707.GC19489@thunk.org>
 <m2zkaiyzjl.fsf@firstfloor.org>
 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
 <1334339612.3796.2.camel@schen9-DESK>
 <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
 <1334341876.3796.8.camel@schen9-DESK>
 <20120413183722.GG26332@thunk.org>
 <1334345213.3796.21.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43833 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2DMTeK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 15:34:10 -0400
Content-Disposition: inline
In-Reply-To: <1334345213.3796.21.camel@schen9-DESK>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 12:26:53PM -0700, Tim Chen wrote:
> 
> The files are sparse files.  So the amount of IO is limited and we are
> not IO constrained.  
> 

... OK, and exactly how sparse are these files?  Can you say something
about the relatistic use case this workload is supposed to represent?
Or is this more of an artificial/micro benchmark?

					- Ted
