From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/9] tune2fs: confirm dangerous operations
Date: Sat, 5 Mar 2016 22:24:18 -0800
Message-ID: <20160306062418.GD22185@birch.djwong.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223811.25381.24546.stgit@birch.djwong.org>
 <D0778787-FF4B-440B-919B-84430E48EFE8@dilger.ca>
 <20160215165300.GF6338@birch.djwong.org>
 <20160306051057.GI10297@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17101 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbcCFGY3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2016 01:24:29 -0500
Content-Disposition: inline
In-Reply-To: <20160306051057.GI10297@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 06, 2016 at 12:10:57AM -0500, Theodore Ts'o wrote:
> I've tried it out, and I think 5 seconds is enough time.  I'll note
> that just hitting the return key will abort the operation, so the user
> has to type 'y', return in order to continue.  In fact I will probaby
> change the prompt so it looks like this:
> 
> Proceed anyway (or wait %d seconds) (y,n) ? <n>

Seems fine to me.

--D

> 
> This should make it clear that if the sysadmin is not sure, just
> hitting return is enough to cancel the operation.
> 
> > > On Feb 13, 2016, at 3:38 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > > 
> > > > Give admins a short amount of time to confirm that they want to
> > > > proceed with a dangerous operation.  Refuse to perform the op
> > > > unless the filesystem is freshly checked.
> > > > 
> > > > Cc: Andreas Dilger <adilger@dilger.ca>
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied.
> 
> 						- Ted
