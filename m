From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Mon, 17 Sep 2012 09:52:15 -0400
Message-ID: <20120917135215.GA26919@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <87fw6get5z.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fw6get5z.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 17, 2012 at 04:21:44PM +0400, Dmitry Monakhov wrote:
> On Wed, 15 Aug 2012 22:46:54 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Wed, Aug 15, 2012 at 09:33:29PM +0300, Marti Raudsepp wrote:
> > > I was moving and deleting some files between two of my ext4 partitions
> > > when it suddenly crashed and dropped me into an kernel oops screen
> > > (below). I'm using ext4 on kernel 3.5.1 (Arch Linux). 
> Ohh, I've missed that gigantic topic, but still i've found the bug.
> patch is available here http://patchwork.ozlabs.org/patch/183649/

Dmitry, we have a patch in mainline already which addresses this, and
it's already backported to v3.5.3 or later.

What version was your patch series based against?

						- Ted
