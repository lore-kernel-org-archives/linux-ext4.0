From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 28/34] tests: test debugfs punch command
Date: Fri, 19 Sep 2014 12:26:32 -0400
Message-ID: <20140919162632.GP26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221423.13646.84263.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37796 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbaISQ0e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 12:26:34 -0400
Content-Disposition: inline
In-Reply-To: <20140913221423.13646.84263.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:14:23PM -0700, Darrick J. Wong wrote:
> Test punching out various parts of sparse files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/f_punch/expect          |  143 +++++++++++++++++++++++++++++++++++++++++
>  tests/f_punch/name            |    1 
>  tests/f_punch/script          |  129 +++++++++++++++++++++++++++++++++++++
>  tests/f_punch_bigalloc/expect |  142 +++++++++++++++++++++++++++++++++++++++++
>  tests/f_punch_bigalloc/name   |    1 
>  tests/f_punch_bigalloc/script |  130 +++++++++++++++++++++++++++++++++++++

Even though these tests are using e2fsck, if the primary goal is to
test debugfs, these should probably renamed d_punch and
d_punch_bigalloc.

Cheers,

					- Ted
