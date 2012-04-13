From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 12:26:53 -0700
Message-ID: <1334345213.3796.21.camel@schen9-DESK>
References: <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
	 <20120324031357.GA5690@tassilo.jf.intel.com>
	 <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
	 <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org>
	 <m2zkaiyzjl.fsf@firstfloor.org>
	 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
	 <1334339612.3796.2.camel@schen9-DESK>
	 <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
	 <1334341876.3796.8.camel@schen9-DESK>  <20120413183722.GG26332@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2DMT0w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 15:26:52 -0400
In-Reply-To: <20120413183722.GG26332@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2012-04-13 at 14:37 -0400, Ted Ts'o wrote:
> On Fri, Apr 13, 2012 at 11:31:16AM -0700, Tim Chen wrote:
> > 
> > Benchmark is working on files on normal hard disk.  
> > However, I have I have a large number
> > of processes (80 processes, one for each cpu), each reading
> > a separate mmaped file.  The files are in the same directory.
> > That makes cache line bouncing on the counters particularly bad
> > due to the large number of processes running.
> 
> OK, so this is with an 80 CPU machine?
> 
> And when you say 20% speed up, do you mean to say we are actually
> being CPU constrained when reading from files on a normal hard disk?
> 

The files are sparse files.  So the amount of IO is limited and we are
not IO constrained.  

Tim

