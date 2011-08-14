From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Sat, 13 Aug 2011 22:06:17 -0400
Message-ID: <20110814020617.GB3524@thunk.org>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
 <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
 <alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
 <4E44E374.7080103@redhat.com>
 <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
 <alpine.LFD.2.00.1108121803210.3088@dhcp-27-109.brq.redhat.com>
 <20110812181330.GG31181@thunk.org>
 <20110812205719.GA1670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47624 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1HNCG2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 22:06:28 -0400
Content-Disposition: inline
In-Reply-To: <20110812205719.GA1670@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 04:57:19PM -0400, Christoph Hellwig wrote:
> > and differences in error code returns for
> > xattrs) and #79 (a failure in the append-only handling which I don't
> > completely understand yet).
> 
> This was discussed on fsdevel lately.  All filesystem but xfs inherit
> the append only bit from directories to files created inside them.
> This not only is not very useful behaviour, but also exposes a bug
> in the vfs that allows to create these new files, but fail the open
> unless using O_APPEND which is against the posix create semantics.

I agree that disabling inheritance of the APPEND_FL flag makes sense.
I propose we do this for ext2/3/4 and any other file systems which is
currently following the ext2/3/4 behavior.

Any objections?

						- Ted
