From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 28/34] tests: test debugfs punch command
Date: Fri, 19 Sep 2014 13:01:47 -0700
Message-ID: <20140919200147.GJ10150@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221423.13646.84263.stgit@birch.djwong.org>
 <20140919162632.GP26995@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37808 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaISUBx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2014 16:01:53 -0400
Content-Disposition: inline
In-Reply-To: <20140919162632.GP26995@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2014 at 12:26:32PM -0400, Theodore Ts'o wrote:
> On Sat, Sep 13, 2014 at 03:14:23PM -0700, Darrick J. Wong wrote:
> > Test punching out various parts of sparse files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/f_punch/expect          |  143 +++++++++++++++++++++++++++++++++++++++++
> >  tests/f_punch/name            |    1 
> >  tests/f_punch/script          |  129 +++++++++++++++++++++++++++++++++++++
> >  tests/f_punch_bigalloc/expect |  142 +++++++++++++++++++++++++++++++++++++++++
> >  tests/f_punch_bigalloc/name   |    1 
> >  tests/f_punch_bigalloc/script |  130 +++++++++++++++++++++++++++++++++++++
> 
> Even though these tests are using e2fsck, if the primary goal is to
> test debugfs, these should probably renamed d_punch and
> d_punch_bigalloc.

Oh.  d==debugfs and f==fsck.  For some reason I had thought 'f' implied 'file'
tests.  Want me to resend with that chnaged?

--D

> 
> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
