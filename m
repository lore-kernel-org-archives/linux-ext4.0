From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Tue, 5 Dec 2006 11:41:28 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612051049200.27677@compserv1>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1>
 <20061204235042.GS33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061204235042.GS33919298@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > As we promised on the linux-ext4 list on October 31, here is the patch
> > that adds secure deletion via a trash-bin functionality for ext4.  It is a
> > compromise solution that combines secure deletion with the trash-bin support
> > (the latter had been requested by even more people than the former :-).
>
> Given that almost all of the code for this uses vfs interfaces and
> only a couple of simple filesystem hooks, is there any reason for
> this being ext4 specific?  i.e. why aren't you hooking the vfs layer
> so we get a single undelete/secure delete implementation for all
> filesystems?

You are right.  Actually, we mentioned it as a benefit number 4 of this
approach in the original post.  Most of the code is not
file-system--specific and can be used by any other (all other?) file
system(s).  The only complication is that only ext2/3/4 and reiser file
systems already support the per-file secure deletion and undelete
attributes.

Since ext4 is in early development now, we believe it'd be easier to get
such code into ext4 than into the main-line VFS.  If there's enough
interested among the kernel maintainers, we'd be happy to move this
functionality to the VFS and provide f/s hooks for
secure-deletion/trash-bin.

I guess, the right thing to do would be to move the common trash-bin
(tb.c and tb.h) code into the /fs and /include/linux directories.
Also, VFS would require just a couple of trivial changes to support
something like '-o trashbin' mount-time option for all file systems.
In addition, individual file systems may support per-file attributes for
this (e.g., ext2/3/4).

Since I just postponed my moving house (I am joining IBM soon) I think we
may have time to try it out this week.

Nikolai.
---------------
Filesystems and Storage Laboratory,
Stony Brook University
