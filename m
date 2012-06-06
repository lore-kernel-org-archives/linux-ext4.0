From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 corruption during unexpected power cycle in the middle of
 writing
Date: Wed, 6 Jun 2012 14:55:26 -0400
Message-ID: <20120606185526.GA10034@thunk.org>
References: <2CE44BD3DBCF9541909CCB42F11CA392825CBF@SFO1EXC-MBXP06.nbttech.com>
 <4FCEEB36.9010102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ming Lei <Ming.Lei@riverbed.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48099 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2FFSze (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jun 2012 14:55:34 -0400
Content-Disposition: inline
In-Reply-To: <4FCEEB36.9010102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 06, 2012 at 12:31:34AM -0500, Eric Sandeen wrote:
> Sort of.  You got:
> 
> > Free blocks count wrong (118366120, counted=76269471).
> > Fix? yes
> > 
> > Free inodes count wrong (30081013, counted=30081004).
> > Fix? yes
> 
> Those are the superblock counters, which aren't journaled - only the bg counters are logged via the journal, IIRC.

This has been partially addressed in e2fsprogs 1.42.3:

commit 2788cc879bbe667d28277e1d660b7e56514e5b30
Author: Andreas Dilger <adilger@whamcloud.com>
Date:   Tue Apr 24 16:22:48 2012 -0400

    e2fsck: quiet harmless inode/blocks errors
    
    Don't consider only an error in the superblock summary as incorrect.
    The kernel does not update this field except at unmount time, so
    don't print errors during a "-n" run if there is nothing else wrong.
    Any other unfixed errors will themselves mark the filesystem invalid.
    
    Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

So e2fsck -n will silence the warnings, and e2fsck -p/-y will just fix
them automatically, although they are still getting printed.  Maybe I
should just mark these messages as one where they just print the fact
that we are adjusting the free blocks count, and avoid using the word
"wrong" --- at least if the filesystem has a journal --- so the error
message isn't as scary/misleading.

						- Ted
