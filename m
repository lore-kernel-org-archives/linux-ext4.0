From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len
 functions
Date: Tue, 7 Dec 2010 13:07:08 -0800
Message-ID: <20101207130708.71c894e9.akpm@linux-foundation.org>
References: <4CFE7347.8030807@redhat.com>
	<4CFE7409.9090609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab0LGVHo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 16:07:44 -0500
In-Reply-To: <4CFE7409.9090609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 07 Dec 2010 11:51:05 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> The addition of 64k block capability in the rec_len_from_disk
> and rec_len_to_disk functions added a bit of math overhead which
> slows down file create workloads needlessly when the architecture
> cannot even support 64k blocks, thanks to page size limits.
> 
> The directory entry checking can also be optimized a bit
> by sprinkling in some unlikely() conditions to move the
> error handling out of line.
> 
> bonnie++ sequential file creates on a 512MB ramdisk speeds up
> from about 2200/s to about 2500/s, about a 14% improvement.
> 

hrm, that's an improbably-large sounding improvement from eliminating
just a few test-n-branches from a pretty heavyweight operation.

