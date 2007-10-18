From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 18 Oct 2007 02:11:55 -0700
Message-ID: <20071018021155.0b648616.akpm@linux-foundation.org>
References: <20070828190551.415127746@sgi.com>
	<20070828190735.292638294@sgi.com>
	<1188432669.3799.35.camel@localhost.localdomain>
	<1188434857.3799.76.camel@localhost.localdomain>
	<1191285346.11737.58.camel@localhost.localdomain>
	<20071004131207.65406a7b.akpm@linux-foundation.org>
	<20071011111849.GC7125@duck.suse.cz>
	<20071017210925.c3c66de5.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710180201060.13576@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sho@tnes.nec.co.jp
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869AbXJRJMM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 05:12:12 -0400
In-Reply-To: <Pine.LNX.4.64.0710180201060.13576@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 18 Oct 2007 02:03:39 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 17 Oct 2007, Andrew Morton wrote:
> 
> > b) what happens when an old ext2 driver tries to read and/or write this
> >    directory entry?  Do we need a compat flag for it?
> 
> Old ext2 only supports up to 4k
> 
> include/linux/ext2_fs.h:
> 
> #define EXT2_MIN_BLOCK_SIZE             1024
> #define EXT2_MAX_BLOCK_SIZE             4096
> #define EXT2_MIN_BLOCK_LOG_SIZE           10
> 
> Should fail to mount the volume since the block size is too large.

should, but does it?

box:/usr/src/25> grep MAX_BLOCK_SIZE fs/ext2/*.[ch] include/linux/ext2*
include/linux/ext2_fs.h:#define EXT2_MAX_BLOCK_SIZE             4096
box:/usr/src/25> 
