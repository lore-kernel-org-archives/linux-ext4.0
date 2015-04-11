From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/22] ext4 crypto: add encryption policy checking
Date: Sat, 11 Apr 2015 09:10:52 -0400
Message-ID: <20150411131052.GE6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-7-git-send-email-tytso@mit.edu>
 <041E1EF0-0767-4CC8-B4BF-9C6552C7E11A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <muslukhovi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34123 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbbDKNKz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2015 09:10:55 -0400
Content-Disposition: inline
In-Reply-To: <041E1EF0-0767-4CC8-B4BF-9C6552C7E11A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2015 at 12:07:16PM -0600, Andreas Dilger wrote:
> > +/* Policy provided via an ioctl on the topmost directory */
> > +struct ext4_encryption_policy {
> > +	char version;
> > +	char contents_encryption_mode;
> > +	char filenames_encryption_mode;
> > +	char master_key_descriptor[EXT4_KEY_DESCRIPTOR_SIZE];
> > +} __attribute__((__packed__));
> 
> It wouldn't be bad to add a padding byte before master_key_descriptor,
> even if this is only passed from the ioctl.  That allows casting the
> key to a numeric value if desired without problems on some arches.

This data structure is only used for the ioctl interface.  The on-disk
format is the struct ext4_encryption_context, where we do have the
padding.

> > +#define EXT4_ENCRYPTION_CONTEXT_FORMAT_V0 0
> 
> Per comments in the call, it is better not to use "0" as a defined
> version, since this is much more likely to be seen accidentally
> (e.g. uninitialized buffer, memory corruption, etc).  Better to
> start with version 1.

I'll make this change.

						- Ted

