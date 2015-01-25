From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v7 1/3] vfs: add support for a lazytime mount option
Date: Sat, 24 Jan 2015 22:03:52 -0500
Message-ID: <20150125030352.GB9287@thunk.org>
References: <1418097870-8232-1-git-send-email-tytso@mit.edu>
 <1418097870-8232-2-git-send-email-tytso@mit.edu>
 <87k30ic0lw.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k30ic0lw.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 19, 2015 at 06:21:31PM +0400, Dmitry Monakhov wrote:
> > +	if (flags & I_DIRTY_INODE)
> > +		flags &= ~I_DIRTY_TIME;
> > +	dirtytime = flags & I_DIRTY_TIME;
> TYPO? 'dirtytime' is always false because you have already cleared that bit.
> Probably you want to do that: 
>         dirtytime = flags & I_DIRTY_TIME;
> 	if (flags & I_DIRTY_INODE)
> 		flags &= ~I_DIRTY_TIME;

Nice catch; I screwed that up in the -v7 version of the patch.  I've
fixed it in the -v8 version that I just sent out.

      	    	    	    	   	- Ted
