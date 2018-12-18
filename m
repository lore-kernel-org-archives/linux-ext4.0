Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:53652 "EHLO
        dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbeLREpp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Dec 2018 23:45:45 -0500
Date: Mon, 17 Dec 2018 23:45:41 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] ext4: avoid declaring fs inconsistent due to invalid
 file handles
Message-ID: <20181218044541.GB25775@mit.edu>
References: <20181213175107.29464-1-tytso@mit.edu>
 <A3D72248-487E-412E-B341-7450C773E81F@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3D72248-487E-412E-B341-7450C773E81F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2018 at 03:53:46PM -0700, Andreas Dilger wrote:
> > +#define EXT4_IGET_NORMAL	1
> > +#define EXT4_IGET_HANDLE	2
> 
> It would be better to make this:
> 
>  enum ext4_iget_flags {
>         EXT4_IGET_RESERVED = 0x00,	/* just guessing, see further below */
> 	EXT4_IGET_NORMAL   = 0x01,
> 	EXT4_IGET_HANDLE   = 0x02,
>  };
> 
> > -	inode = ext4_iget(sb, ino);
> > +	inode = ext4_iget(sb, ino, 0);
> 
> What does "0" mean?  It isn't in the list of EXT4_IGET_* flags.  I'm guessing it
> means that access to reserved or otherwise invalid inodes is allowed?

The flags are boolean OR'ed together, much like O_TRUNC | O_CREAT,
etc.  So an enum isn't really appropriate.  So 0 means we're not
enforcing "must be a normal inode" rules, and we're also not going to
avoid throwing an EXT4_ERROR if the inode number is invalid.

I had thought it was obvious that flags can be or'ed together, and
that "modes" are what might use an enum.  I personally like flags
because the can be more expressive, although I can see that "modes"
are simpler since there is a much smaller set of valid modes, and you
don't have to worry about define what happens when flags interact in
unusual/unexpected ways.

It sounds like should add more explicit documentation at the very
least so it's more clear what's going on.

      	      	   	 	      - Ted
