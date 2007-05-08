From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Check journal inode sanity and recreate journal
Date: Tue, 8 May 2007 01:40:34 -0400
Message-ID: <20070508054034.GA28110@thunk.org>
References: <1173906827.3076.5.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44909 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968013AbXEHFko (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 May 2007 01:40:44 -0400
Content-Disposition: inline
In-Reply-To: <1173906827.3076.5.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 15, 2007 at 02:43:47AM +0530, Kalpak Shah wrote:
> Index: e2fsprogs-1.39/lib/ext2fs/mkjournal.c
> ===================================================================
> --- e2fsprogs-1.39.orig/lib/ext2fs/mkjournal.c
> +++ e2fsprogs-1.39/lib/ext2fs/mkjournal.c
> +	if (fs->super->s_blocks_count < 2048) {
> +		fputs(("\nFilesystem too small for a journal\n"), stderr);
> +		return 0;
> +	}

Code in lib/ext2fs isn't allowed to do any output to stdio (except for
debugging purposes).  It causes internationalization problems, and
it's just in general a bad idea for ext2fs library code to try to do
any UI.

						- Ted
