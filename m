From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 18 Oct 2007 02:03:39 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710180201060.13576@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com>
 <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain>
 <1191285346.11737.58.camel@localhost.localdomain>
 <20071004131207.65406a7b.akpm@linux-foundation.org> <20071011111849.GC7125@duck.suse.cz>
 <20071017210925.c3c66de5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sho@tnes.nec.co.jp
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53981 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754845AbXJRJDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2007 05:03:40 -0400
In-Reply-To: <20071017210925.c3c66de5.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 17 Oct 2007, Andrew Morton wrote:

> b) what happens when an old ext2 driver tries to read and/or write this
>    directory entry?  Do we need a compat flag for it?

Old ext2 only supports up to 4k

include/linux/ext2_fs.h:

#define EXT2_MIN_BLOCK_SIZE             1024
#define EXT2_MAX_BLOCK_SIZE             4096
#define EXT2_MIN_BLOCK_LOG_SIZE           10

Should fail to mount the volume since the block size is too large.
