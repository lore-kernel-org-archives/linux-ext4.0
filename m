From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 35/47] resize2fs: convert fs to and from 64bit mode
Date: Mon, 15 Dec 2014 12:46:04 -0500
Message-ID: <20141215174604.GC21646@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215433.883.51160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57228 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaLORqJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 12:46:09 -0500
Content-Disposition: inline
In-Reply-To: <20141107215433.883.51160.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:54:33PM -0800, Darrick J. Wong wrote:
> resize2fs does its magic by loading a filesystem, duplicating the
> in-memory image of that fs, moving relevant blocks out of the way of
> whatever new metadata get created, and finally writing everything back
> out to disk.  Enabling 64bit mode enlarges the group descriptors,
> which makes resize2fs a reasonable vehicle for taking care of the rest
> of the bookkeeping requirements, so add to resize2fs the ability to
> convert a filesystem to 64bit mode and back.
> 
> v2: Fix a couple of minor resource leaks; make it more explicit to the
> user what we're doing to the fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: TR Reardon <thomas_reardon@hotmail.com>

Thanks, applied.

					- Ted
