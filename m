From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix endian checking bits
Date: Wed, 5 Nov 2014 11:09:06 -0500
Message-ID: <20141105160906.GA27083@thunk.org>
References: <20141104232911.GC10043@birch.djwong.org>
 <545962B3.80003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40317 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaKEQJP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Nov 2014 11:09:15 -0500
Content-Disposition: inline
In-Reply-To: <545962B3.80003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2014 at 05:35:15PM -0600, Eric Sandeen wrote:
> On 11/4/14 5:29 PM, Darrick J. Wong wrote:
> > Commit 3e683eef936e6d ("define bitwise types and annotate conversion
> > routines") broke the build on various platforms.  Turns out that
> > crossing our fingers wasn't such a good idea, so just define it
> > separately.
> 
> sooorrry!
> 
> Seems fine, thanks.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
