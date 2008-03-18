From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Tue, 18 Mar 2008 07:01:45 -0400
Message-ID: <20080318110145.GQ8368@mit.edu>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com> <20080318042339.GO8368@mit.edu> <47DF5045.1000108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35882 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYCRLC2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2008 07:02:28 -0400
Content-Disposition: inline
In-Reply-To: <47DF5045.1000108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 18, 2008 at 12:16:53AM -0500, Eric Sandeen wrote:
> Well, I think that what I'm suggesting (but it's late, and I'm tired, so
> it's hard for me to tell for sure... ;) is that there is no special
> anything.  You simply take the specified -T arguments in order, and use
> that as the search/override order for any setting found in the stanzas
> specified.  This would probably be simplest to code, actually, as well
> as simplest to document, and even most powerful/flexible for the user.
> 
> But, I suppose I can live with
> 
>      -T [fs_type,][size_type,]user_type[,additional_type...]
> 
> which is reasonably clear, though... we just need to document that there
> are 7 special stanza names in 2 categories, which the code will put
> there *for* you if you don't put it them the right place, yourself.
> It's just, IMHO, a more complicated and restricted specification for the
> option.

Well, the problem is that we need to be compatible with previous
behavior, where the size type could be set automatically, and where
the filesystem type was intuited from /sbin/mke2fs.ext3.  So it was
clear that

	/sbin/mkfs.ext4 /dev/sda1

should be equivalent to 

	/sbin/mke2fs -T ext4 /dev/sda

But in that case, then what should this mean:

	/sbin/mkfs.ext4 -T news /dev/sda1

The user very clearly wanted an ext4 filesystem, so we need to
give him the feature flag settings in the ext4 stanza, but she probably
also wanted inode ratio setting implied by -T news.

-----

If this is too confusing, one of the things which we *could* do is
decouple the filesystem size from everything else.  "mke2fs -t" is a
deprecated alias for "mke2fs -c".  We could make "/sbin/mkfs.ext4"
equivalent to "mke2fs -t ext4".  Then we don't have to explain how
the filesystem type handling prepends onto the -T arguments.

If we do that, then we could just say that the size_type (floppy,
small, default) is only used if there is no -T option at all.  I would
probably still do the chaining, just because I think it's a cool
feature, but documenting it becomes simpler because it removes a lot
of the special cases.

I rejected this approach originally because it would mean reusing the
-t option right away.  But maybe this would be easier for users to
understand, and easier to document in the man pages, and maybe that's
an overriding consideration.

Regards,

						- Ted
