From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 blocks up
Date: Mon, 2 Jul 2012 19:53:41 +0200
Message-ID: <20120702175341.GN6679@quack.suse.cz>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
 <20120702151442.GB18074@thunk.org>
 <20120702164548.GD18074@thunk.org>
 <4FF1D22D.2070804@redhat.com>
 <20120702173104.GK6679@quack.suse.cz>
 <20120702174342.GA5795@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120702174342.GA5795@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 02-07-12 13:43:42, Ted Tso wrote:
> On Mon, Jul 02, 2012 at 07:31:04PM +0200, Jan Kara wrote:
> >   Yes, I can hang the kernel on this test with basically any filesystem
> > when running long enough. My freezing patches should fix that - currently
> > waiting for Al to merge them...
> 
> So this is different from your suspend/resume patches, then?
  I'm not sure what suspend/resume patches do you mean so I suspect it
might be it :)

> Can you send me a pointer to your patches?  Is this something that Al
  http://www.spinics.net/lists/kernel/msg1355763.html

> will hopefully merge before 3.5 is released?
  Hopefully. He is certainly aware of the series and wants to merge it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
