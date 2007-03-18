From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs coverity patch <cid-1.diff>
Date: Sun, 18 Mar 2007 11:32:05 -0600
Message-ID: <20070318173205.GJ6373@schatzie.adilger.int>
References: <200702100208.l1A28GC2005813@igsi.llnl.gov> <20070318134014.GA10086@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Brian D. Behlendorf" <behlendorf1@llnl.gov>,
	linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44323 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbXCRRcJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Mar 2007 13:32:09 -0400
Content-Disposition: inline
In-Reply-To: <20070318134014.GA10086@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 18, 2007  09:40 -0400, Theodore Tso wrote:
> On Fri, Feb 09, 2007 at 06:08:16PM -0800, Brian D. Behlendorf wrote:
> > Coverity ID: 2: Checked Return
> 
> Would I be right in assuming this should be Coverity ID 1, and not 2?
> (cid-2.diff is also labelled as Coverity ID 1).
> 
> What is Coverity ID's, anyway?  I assume they are something you
> locally assigned?

Yes, this is just the error number within a given software project
at a particular site.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
