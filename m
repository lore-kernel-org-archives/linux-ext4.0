From: tytso@mit.edu
Subject: Re: About strange behaviour of ext4 allocation algorithm
Date: Wed, 23 Dec 2009 07:07:51 -0500
Message-ID: <20091223120751.GA21594@thunk.org>
References: <41BA663C8B2F72499F48B0EF991C188E047890DF84@RU-EXSTRCL1.ru.corp.acronis.com>
 <E1904714-A014-422C-91BF-E39E736285CD@sun.com>
 <41BA663C8B2F72499F48B0EF991C188E0478A366D3@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50404 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZLWMH6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 07:07:58 -0500
Content-Disposition: inline
In-Reply-To: <41BA663C8B2F72499F48B0EF991C188E0478A366D3@RU-EXSTRCL1.ru.corp.acronis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 23, 2009 at 01:52:48PM +0300, Vyacheslav Dubeyko wrote:
>  
> I use kernel: 2.6.29.4-167.fc11.i686.PAE #1 SMP Wed May 27 17:28:22
> EDT 2009 i686 i686 i386 GNU/Linux.

Yeah, that was before a massive number of changes to the ext4
allocator.  The changes to the allocators which speed up fsck
described here:

http://thunk.org/tytso/blog/2009/02/26/fast-ext4-fsck-times-revisited/

All went in *after* 2.6.29.  That is, how the block and inode
allocators worked change significantly between 2.6.29 and 2.6.31.

> > If you delete your file, without reformatting the filesystem, and
> > then re-run the test, does it produce the same results?  If not,
> > then it is likely you are seeing the problem with uninitialized
> > groups that was fixed a month or two ago.
> 
> After deletion of the file and re-run test (without reformatting the
> filesystem) I have slightly different extents' tree. Index block
> (depth of the tree = 1) has changed place and several extents has
> another sizes. But nature of the extents' sequence is the same.

The change which Andreas was referring to --- taking out the bias
against opening up uninitialized block groups for allocations until
absolutely necessary, which had a tendency to cause unnecessary
fragmentation --- was merged into mainline between 2.6.30 and 2.6.31.

Best regards,

						- Ted

