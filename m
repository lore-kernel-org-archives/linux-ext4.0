From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
Date: Fri, 13 Jul 2007 02:05:29 -0700
Message-ID: <20070713020529.1486491f.akpm@linux-foundation.org>
References: <1183275482.4010.133.camel@localhost.localdomain>
	<20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andy Whitcroft <apw@shadowen.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Jul 2007 16:32:47 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	brelse(bh);
> > +	up_write(&EXT4_I(inode)->xattr_sem);
> > +	return error;
> > +}
> > +
> 
> We're doing GFP_KERNEL memory allocations while holding xattr_sem.  This
> can cause the VM to reenter the filesystem, perhaps taking i_mutex and/or
> i_truncate_sem and/or journal_start() (I forget whether this still
> happens).  Have we checked whether this can occur and if so, whether we are
> OK from a lock ranking POV?  Bear in mind that journalled-data mode is more
> complex in this regard.

I notice that everyone carefully avoided addressing this ;)

Oh well, hopefully people are testing with lockdep enabled.  As long
as the fs is put under extreme memory pressure, most bugs should be reported.

Except lockdep doesn't know about journal_start(), which has ranking
requirements similar to a semaphore.  Nor does it know about lock_page().
We already have hard-to-hit but deadlockable bugs in this area.


