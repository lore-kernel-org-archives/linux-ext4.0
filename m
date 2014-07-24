From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Is warn_on() right reply for i/o error?
Date: Thu, 24 Jul 2014 15:29:38 -0400
Message-ID: <20140724192938.GM6673@thunk.org>
References: <20140724152721.GA4771@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, jack@suse.cz
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140724152721.GA4771@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 24, 2014 at 05:27:22PM +0200, Pavel Machek wrote:
> Hi!
> 
> Just... I know, I should not be unscrewing hard drive cover while
> operating.
> 
> But on the other hand... WARN_ON() does not sound like right reply for
> a disk failure... right?

Actually, it can be worse than that.  If a hard drive disappears out
from under you while writeback is happening, it's possible to get
crashes in bdi_writeack_workfn() because you can have races between
bdi_unregister() and bdi_writeback_workfn(), since the latter requeues
itself and flush_delayed_work() can return while
bdi_writeback_workfn() is still executing.

This looks like it's a related problem, where the block device gets
unregistered (and this happens in the block device layer without it
telling the file system that the disk drive is about to disappear out
from under it), and occasionally, Bad Stuff Happens.  :-(

     	 	       	   	 	    - Ted
