From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V3 1/3] tune2fs: Make e2fsprogs handle ENOSPC better
	with inode resize
Date: Fri, 21 Aug 2009 08:25:02 -0400
Message-ID: <20090821122502.GC9529@mit.edu>
References: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090820070636.GB26492@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49763 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZHUMZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2009 08:25:03 -0400
Content-Disposition: inline
In-Reply-To: <20090820070636.GB26492@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:36:36PM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> Any chance on getting this patch series merged ?

Thanks for the reminder/prod; I've merged them into into the maint
branch of e2fsprogs, with some minor whitespace and spelling fixups.

       	  	     	       	     - Ted
