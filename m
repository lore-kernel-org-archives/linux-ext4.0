From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Wed, 11 Jul 2007 06:41:10 -0600
Message-ID: <20070711124110.GZ6417@schatzie.adilger.int>
References: <20070710112307.34c2ba5c@rx8> <20070711041213.GH6417@schatzie.adilger.int> <20070711003004.531c9307@naruto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:42535 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbXGKMlM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 08:41:12 -0400
Content-Disposition: inline
In-Reply-To: <20070711003004.531c9307@naruto>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 11, 2007  00:30 -0500, Jose R. Santos wrote:
> On Tue, 10 Jul 2007 22:12:14 -0600
> Andreas Dilger <adilger@clusterfs.com> wrote:
> > You might also want to test out placement of the journal in the middle
> > of the filesystem, the U. Wisconsin folks tested this in one of their
> > papers and showed some noticable improvements.  That isn't exactly
> > related, but it is a relatively simple tweak to mke2fs/tune2fs to give
> > it an allocation goal of group_desc[s_groups_count / 2].bg_inode_table
> > (to put it past inode table in middle group).
> 
> Make sense.  Do you have a link to the paper?

I don't have a URL, but if you search for "IRON ext3" and go to Remzi's
site it is called "Analysis and Evolution of Journaling File Systems".

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
