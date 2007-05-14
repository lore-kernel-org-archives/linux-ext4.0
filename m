From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resolve duplicate flag no for PG_lazyfree
Date: Mon, 14 May 2007 14:06:19 -0400
Message-ID: <20070514180618.GB9399@thunk.org>
References: <379110250.28666@ustc.edu.cn> <20070513224630.3cd0cb54.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <fengguang.wu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Rik van Riel <riel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759616AbXENUDg@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070513224630.3cd0cb54.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 13, 2007 at 10:46:30PM -0700, Andrew Morton wrote:
> otoh, the intersection between pages which are PageBooked() and pages which
> are PageLazyFree() should be zreo, so it'd be good to actually formalise
> this reuse within the ext4 patches.
> 
> otoh2, PageLazyFree() could have reused PG_owner_priv_1.
> 
> Rik, Ted: any thoughts?  We do need to scrimp on page flags: when we
> finally run out, we're screwed.

It makes sense to me.  PG_lazyfree is currently only in -mm, right?  I
don't see it in my git tree.  It would probably would be a good idea
to make sure that we check to add some sanity checking code if it
isn't there already that PG_lazyfree isn't already set when try to set
PG_lazyfree (just in case there is a bug in the future which causes
the should-never-happen case of trying lazy free a PageBooked page).

						- Ted
