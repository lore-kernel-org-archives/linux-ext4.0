From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Mon, 1 Apr 2013 14:17:18 -0400
Message-ID: <20130401181718.GB22443@thunk.org>
References: <51546EED.8030507@redhat.com>
 <5154AAB4.2000701@redhat.com>
 <5159A8D5.1000204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57874 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab3DASRY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 14:17:24 -0400
Content-Disposition: inline
In-Reply-To: <5159A8D5.1000204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 10:33:41AM -0500, Eric Sandeen wrote:
> +		/* Have we already started readdir on this dx dir? */
> +		if (filp->private_data) {
> +			err = -EINVAL;
> +			goto hash32bits_out;
> +		}

I'm not sure how much we care, but if filp->private_data is non-NULL
and filp->f_pos == 0, then the application must have called
rewinddir(), and at that point it would be fair game for us to free
the rb_tree (see the code in ext4_dx_readdir() just after the comment
"Some one has messed with f_pos; reset the world".)

This would allow a bit more flexibility than just requiring that the
ioctl be issued just after the opendir(), and allow it just after a
call to rewinddir().

This this would invalidate any previously issued telldir() cookies,
but according to SuSv3, telldir() cookies are not guaranteed to be
consistent after a rewinddir() or a closedir(), so it would be
standards compliant to do this.

						- Ted
