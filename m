From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 4 Oct 2007 13:12:07 -0700
Message-ID: <20071004131207.65406a7b.akpm@linux-foundation.org>
References: <20070828190551.415127746@sgi.com>
	<20070828190735.292638294@sgi.com>
	<1188432669.3799.35.camel@localhost.localdomain>
	<1188434857.3799.76.camel@localhost.localdomain>
	<1191285346.11737.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sho@tnes.nec.co.jp, jack@suse.cz, clameter@sgi.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415AbXJDUMf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2007 16:12:35 -0400
In-Reply-To: <1191285346.11737.58.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 01 Oct 2007 17:35:46 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> ext2: Avoid rec_len overflow with 64KB block size
> 
> From: Jan Kara <jack@suse.cz>
> 
> With 64KB blocksize, a directory entry can have size 64KB which does not fit
> into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> value when read from / written to disk.

This patch clashes in non-trivial ways with
ext2-convert-to-new-aops-fix.patch and perhaps other things which are
already queued for 2.6.24 inclusion, so I'll need to ask for an updated
patch, please.

Also, I'm planing on merging the ext2 reservations code into 2.6.24, so if
we're aiming for complete support of 64k blocksize in 2.6.24's ext2,
additional testing and checking will be needed.
