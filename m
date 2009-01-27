From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: 64-bit e2fsprogs tree for testing
Date: Tue, 27 Jan 2009 00:29:36 -0500
Message-ID: <20090127052936.GB13163@shell>
References: <20090123002815.GJ12643@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZA0F3i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 00:29:38 -0500
Content-Disposition: inline
In-Reply-To: <20090123002815.GJ12643@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 22, 2009 at 07:28:15PM -0500, Valerie Aurora Henson wrote:
> Hi folks,
> 
> The e2fsprogs 64-bit branch is available for public testing.  This
> branch adds support for creating, checking, etc. ext4 file systems
> with more than 2^32 blocks - i.e., more than 16TB on most systems.
> This is for TESTING ONLY - don't put any data you care about on it!
> 
> The public git repository is available here:
> 
> git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> 
> The branch is "64bit".
> 
> Known bugs:
> 
> * compilation of programs using certain libe2p routines may fail 
>   (chattr, lsattr)
> * fsck will fail if directories contain blocks above the 32-bit
>   boundary

I just finished and pushed the fix for the second item (64-bit
dblists).

Note that I'll be unavailable for the next week while I recover from
shoulder surgery.

-VAL
