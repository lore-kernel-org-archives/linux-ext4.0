From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 69/73] ext2: Add fallthru support [ver #2]
Date: Sun, 26 Feb 2012 19:33:12 -0500
Message-ID: <20120227003312.GC8044@thunk.org>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221180611.25235.63025.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	valerie.aurora@gmail.com, linux-kernel@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>,
	Jan Blunck <jblunck@suse.de>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36832 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab2B0C2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Feb 2012 21:28:03 -0500
Content-Disposition: inline
In-Reply-To: <20120221180611.25235.63025.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 21, 2012 at 06:06:11PM +0000, David Howells wrote:
> From: Valerie Aurora <vaurora@redhat.com>
> 
> Add support for fallthru directory entries to ext2.

As I mentioned, I wonder if it makes sense combine the patches for
whiteout and fallthrough director entries into a single patch.  Given
that the two patches modify the same functions, and in some cases
second modifies lines added or modified by first, it just makes life
easier if the two are folded together.

> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -506,11 +506,14 @@ struct ext2_super_block {
>  #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008
>  #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
>  #define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
> +/* ext3/4 incompat flags take up the intervening constants */
> +#define EXT2_FEATURE_INCOMPAT_FALLTHRU		0x2000

... and the codepoint 0x2000 in the INCOMPAT mask has since already
been assigned.

As I mentioned in a comment to the previous patch, any objections if
you combine these two fields into a single ROCOMPAT feature?

#define EXT2_FEATURE_RO_COMPAT_UNION_MOUNT	0x0800

						- Ted
