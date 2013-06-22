From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 08:56:04 -0400
Message-ID: <20130622125604.GD4727@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>
 <20130621210556.GB10582@thunk.org>
 <C0F0BC787567C848B2C90989451123DA2363CAFF@ATLEXMBX4.ARRS.ARRISI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Joseph D. Wagner" <joe@josephdwagner.info>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ryan Lortie <desrt@desrt.ca>
To: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60249 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab3FVM4K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jun 2013 08:56:10 -0400
Content-Disposition: inline
In-Reply-To: <C0F0BC787567C848B2C90989451123DA2363CAFF@ATLEXMBX4.ARRS.ARRISI.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 09:49:26PM +0000, Sidorov, Andrei wrote:
> But there is no need to mount entire fs with data journalling mode.
> In fact I find per-file data journalling extremely useful. It would
> be even more useful if it allowed regular users to set journalling
> mode on specific file and there was some way to designate rewrite
> transaction boundaries (even 128k would cover a lot of
> small-but-important-file use cases).

Note that at the moment, the +j flag is only honored in nodelalloc
mode.  Since delayed allocation is enabled by defalut the per-file
data journal flag is ignored.  This is something that we could fix, in
theory.  It would be possible to teach ext4_writepages how to allocate
the block(s) and write the data block(s) in the same journal
transaction --- but that functionality does not exist today.

So if you want to use the +j flag, you have to mount the file system
with the non-standard nodelalloc mount option.  And that's actually
sufficient to be bug-for-bug compatible with ext3 in terms of the
commit of the transaction which contains the rename operation first
forcing the file out to disk first.

Although as both I and Dave Chinner have pointed out, it's a bad idea
for generic application to depend on file system implementation,
because we do reserve the right to change those implementation details
if it would help improve the file system's performance or reliability.

> As for now it is a best choice for app running with root privileges
> for rewriting files <= page size.

The best choice for an application rewriting files <= a single 4k
block is to use O_DIRECT to rewrite the contents of the file, using a
4k buffer which is zero padded.  This is the most performant, uses the
fewest write cycles for a SSD, etc.

       	     				- Ted
