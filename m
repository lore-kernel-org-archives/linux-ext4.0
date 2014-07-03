From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Thu, 3 Jul 2014 19:17:48 -0400
Message-ID: <20140703231748.GA5320@thunk.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
 <20140701084206.GG9743@birch.djwong.org>
 <53B2A47F.90903@samsung.com>
 <20140701155812.GD2775@thunk.org>
 <20140701163646.GA3126@wallace>
 <20140702121752.37e1f181@archvile>
 <CAFnufp0Fm8F=qu87R5LiOAunc_2axk4+g9J4euOjaCcNak0MnQ@mail.gmail.com>
 <20140703171434.GA15790@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matteo Croce <technoboy85@gmail.com>,
	David Jander <david@protonic.nl>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44193 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaGCXR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jul 2014 19:17:57 -0400
Content-Disposition: inline
In-Reply-To: <20140703171434.GA15790@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 03, 2014 at 01:14:34PM -0400, Eric Whitney wrote:
> 
> FWIW, I've also been able to reproduce that failure scenario on an
> x86_64 KVM with raw virtio disks alone.  It's just a lot harder to
> get there with that configuration - many more trials required.

What configuration are you using when you see the failure using x86_64
KVM with raw virtio?  Is this using kvm-xfstests, or some other setup?
And which file system is getting corrupted?

Because with kvm-xfstests the root file system is a read-only
snapshot, and the "mmcblk0p3" device which you show before is clearly
not the virtio device....

						- Ted
