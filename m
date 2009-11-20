From: Jan Kara <jack@suse.cz>
Subject: Re: norecovery option for ext3
Date: Fri, 20 Nov 2009 21:54:59 +0100
Message-ID: <20091120205459.GB15631@duck.suse.cz>
References: <20091120122403.GD15422@duck.suse.cz>
 <4B06B9CA.1030502@redhat.com>
 <745F9F90-6F43-4DA1-92B7-0AC09E07981C@sun.com>
 <4B06D83F.8040203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZKTUyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 15:54:54 -0500
Content-Disposition: inline
In-Reply-To: <4B06D83F.8040203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 20-11-09 11:56:15, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On 2009-11-20, at 07:46, Eric Sandeen wrote:
> >> Jan Kara wrote:
> >>>  I've tried to test noload/norecovery option of ext3 and I've found
> >>> it simply does not work. The filesystem does not even mount.
> > 
> >>>  Given that nobody used the option (OK, some googling shows that
> >>> somebody tried to use it in *2.4.9* kernel and it didn't work even
> >>> there - Stephen Tweedie comments that it's an obsolete option meant
> >>> for use during fs development) and seeing how badly corrupted the
> >>> filesystem is when you don't replay the journal, I'd just remove the
> >>> option. Any opinions?
> >>
> >> Oh, sigh.  Sorry, didn't actually, er, test it, since I was just
> >> adding an alias for the option... bleah.
> >>
> >> I think we should fix it; there are cases when you may want to mount
> >> that way, I think - for example, otherwise there is no way at all to
> >> mounta block device which is marked readonly...
> > 
> > 
> > Won't this require implementing "no journal" mode for ext3?  Seems like
> > a lot of effort, when ext4 does the same thing (i.e. they could just
> > mount the filesystem "-t ext4 -o norecovery" if they really, really need
> > to do that).
> 
> I don't see why it would need nojournal mode; you'd have to:
> 
> mount -o ro,norecovery
> 
> anyway, and if it's ro the journal should be non-operational anyway right?
> 
> (Jan, did you mount -o norecovery or -o ro,norecovery in your tests?)
  Actually, just -o norecovery but after the oops I've looked at the code
and concluded that -o ro won't help the oops anyway... But yes, fixing the
code in read-only mode should be possible.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
