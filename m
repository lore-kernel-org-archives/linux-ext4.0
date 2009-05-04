From: Theodore Tso <tytso@mit.edu>
Subject: Re: Build error with latest e2fsprogs
Date: Mon, 4 May 2009 07:41:51 -0400
Message-ID: <20090504114151.GC6766@mit.edu>
References: <20090504105817.GA21923@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36968 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZEDLlw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 07:41:52 -0400
Content-Disposition: inline
In-Reply-To: <20090504105817.GA21923@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2009 at 04:28:17PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> Finding the below build error with latest e2fsprogs. I guess you missed
> a git add.

Whoops, sorry about that.  Fixed now.  (lib/ext2fs/fiemap.h just needs
to be a copy of the include/linux/fiemap.h from a recent kernel
source.)

						- Ted
