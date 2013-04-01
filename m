From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: take i_mutex in __page_symlink()
Date: Mon, 1 Apr 2013 13:38:24 -0400
Message-ID: <20130401173824.GA22443@thunk.org>
References: <20130328140635.GA32635@thunk.org>
 <1364829822-18989-1-git-send-email-tytso@mit.edu>
 <20130401163538.GC21522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130401163538.GC21522@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 01, 2013 at 05:35:38PM +0100, Al Viro wrote:
> > This was discovered by the addition of a new ext4 debugging assertion
> > which checked to make sure i_mutex was locked before calling
> > ext4_truncate().
> 
> 	I doubt that it's worth doing (inode has just been created and
> nobody else should have references to it - it's not fully set up, after
> all)...

Well, my other option is to drop the assert in ext4_truncate(), which
I thought was a good thing from a perspective of defensive
programming, or to grab the mutex in ext4_symlink() which is what
calles __page_symlink().

Would you prefer that we take the mutex in ext4_symlink() instead?

      	  	      	      	  	- Ted
