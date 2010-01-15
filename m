From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the mount/umount into the VFS layer
Date: Fri, 15 Jan 2010 13:07:22 -0500
Message-ID: <20100115180722.GD3482@shell>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com> <20100114081448.GI19799@ZenIV.linux.org.uk> <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com> <20100115012421.GA28498@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100115012421.GA28498@discord.disaster>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 15, 2010 at 12:24:21PM +1100, Dave Chinner wrote:
> 
> FWIW, having a general event channel for reporting filesystem events like
> mount, enospc, corruption, etc makes a lot of sense to me.
> Especially from the point of view that they can be also be tied into
> automated filesystem test harnesses easily....

Mmm, yummy!  Is this perhaps a topic for the next file systems workshop?

(When _is_ the next file systems workshop?)

-VAL
