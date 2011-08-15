From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Mon, 15 Aug 2011 13:19:02 +0200
Message-ID: <20110815111902.GA6597@quack.suse.cz>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
 <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
 <alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
 <4E44E374.7080103@redhat.com>
 <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
 <alpine.LFD.2.00.1108121803210.3088@dhcp-27-109.brq.redhat.com>
 <20110812181330.GG31181@thunk.org>
 <20110812205719.GA1670@infradead.org>
 <20110814020617.GB3524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1HOLTG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 07:19:06 -0400
Content-Disposition: inline
In-Reply-To: <20110814020617.GB3524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 13-08-11 22:06:17, Ted Tso wrote:
> On Fri, Aug 12, 2011 at 04:57:19PM -0400, Christoph Hellwig wrote:
> > > and differences in error code returns for
> > > xattrs) and #79 (a failure in the append-only handling which I don't
> > > completely understand yet).
> > 
> > This was discussed on fsdevel lately.  All filesystem but xfs inherit
> > the append only bit from directories to files created inside them.
> > This not only is not very useful behaviour, but also exposes a bug
> > in the vfs that allows to create these new files, but fail the open
> > unless using O_APPEND which is against the posix create semantics.
> 
> I agree that disabling inheritance of the APPEND_FL flag makes sense.
> I propose we do this for ext2/3/4 and any other file systems which is
> currently following the ext2/3/4 behavior.
> 
> Any objections?
  I'm fine with that. It also looks more like a bug (ommission) than
anything else.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
