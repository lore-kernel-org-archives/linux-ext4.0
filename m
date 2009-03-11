From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Wed, 11 Mar 2009 17:41:05 -0500
Message-ID: <49B83E01.1040605@redhat.com>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60123 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZCKWlS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Mar 2009 18:41:18 -0400
In-Reply-To: <1235451952-2726-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Add an ioctl which forces all of the delay allocated blocks to be
> allocated.  This also provides a function ext4_alloc_da_blocks() which
> will be used by the following commits to force files to be fully
> allocated to preserve application-expected ext3 behaviour.
> 

Is it worth checking whether a) the file has delalloc blocks, and/or b)
whether the mapping is dirty before we spin off a filemap_flush?

-Eric
