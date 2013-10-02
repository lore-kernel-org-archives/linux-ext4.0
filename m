From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of
 directory inodes
Date: Wed, 2 Oct 2013 17:25:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310021717540.1924@localhost.localdomain>
References: <20131001160817.GA2295@kvack.org> <20131002144759.GB32181@quack.suse.cz> <524C3574.7020106@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3JBPZd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 11:25:33 -0400
In-Reply-To: <524C3574.7020106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2 Oct 2013, Eric Sandeen wrote:

> Date: Wed, 02 Oct 2013 10:02:12 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: Jan Kara <jack@suse.cz>
> Cc: Benjamin LaHaise <bcrl@kvack.org>, Theodore Ts'o <tytso@mit.edu>,
>     Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of
>     directory inodes
> 
> On 10/2/13 9:47 AM, Jan Kara wrote:
> > On Tue 01-10-13 12:08:17, Benjamin LaHaise wrote:
> >> While investigating a performance regression during migration of the
> >> Solace product from an older kernel running ext3 to a 3.x kernel running
> >> ext4, the change in allocation policies between ext3 and ext4 were found
> >> to have caused a 10-50% decrease (depending on the test) in I/O
> >> throughput.  In order to extract more parallelism from the filesystem,
> >> this particular use-case has 100 subdirectories off of the root
> >> directory of an ext4 filesystem in which files are created in a
> >> round-robin fashion.  The subdirectories are used in order to increase
> >> the number of metadata operations that can occur in parallel.  With the
> >> older setup on ext3, files were created sequentially, while using ext4
> >> resulted in the files being spread out across block groups.
> >>
> >> To avoid this change in allocation policies, introduce the noorlov mount
> >> parameter to ext4.  This parameter changes allocation policy such that new
> >> subdirectories in the filesystem are allocated in the same block group
> >> as the parent subdirectory.  With the subdirectories in the same block
> >> group, the allocation policy once again results in files being laid out
> >> sequentially on disk, restoring performance.
> >   Frankly, I'm not very fond of a mount option for tweaking inode allocation
> > policy. OTOH the regression is large enough that we should address it
> > somehow.
> > 
> > So I suppose if your application doesn't use the root directory as a base
> > but some other directory on ext4 filesystem, everything is OK, isn't it?
> > Because the root directory is special in the Orlov allocator and that is
> > where the randomness happens.
> > 
> > If I'm right about the source of the problem, we could use TOPDIR inode
> > flag to handle this. Currently Orlov allocator treats directories with
> > TOPDIR flag set the same way as the root directory. Sadly the root
> > directory itself is hardcoded in the allocator but we could remove that
> > just keep the check for TOPDIR flag. To handle backward compatibility,
> > we would set TOPDIR for root inode during mount first time we mount the fs
> > with the new kernel (needs some flag in the superblock).
> > 
> > Hum, so when I wrote this I'm not sure this is that much better than a
> > mount option. But it's a possibility :). What do others think?
> 
> I'm right with you on thinking a mount option should be a last resort.
> 
> One thing I'm curious about - what changed from ext3 to ext4?  I thought
> both defaulted to orlov and the same type of allocation behavior, more
> or less.  I guess one change is that the "oldalloc" mount
> option went away.
> 
> (if it does come back, it should probably mirror what we had before,
> which was "oldalloc" not "noorlov" right?)

Well, I guess I am to blame see commit
4113c4caa4f355b8ff8b7ff0510c29c9d00d30b3 which removed the old
oldalloc mount option as a part of the effort to actually reduce the
number of mount options :)

So we can either bring back oldalloc option use the TOPDIR inode
flag as Jan suggested. In this case having the inode flag seems like
a better option to me.

Thanks!
-Lukas


> 
> -Eric
> 
> > 								Honza
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
