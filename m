From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs-1.39-tyt3
Date: Tue, 1 May 2007 12:49:56 -0600
Message-ID: <20070501184956.GF5722@schatzie.adilger.int>
References: <E1HiXhp-0002Fi-Mm@candygram.thunk.org> <20070501075641.GB5967@schatzie.adilger.int> <20070501150545.GA26093@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58239 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161691AbXEASt7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 May 2007 14:49:59 -0400
Content-Disposition: inline
In-Reply-To: <20070501150545.GA26093@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 01, 2007  11:05 -0400, Theodore Tso wrote:
> Speaking of SCM's, how wedded is Clustrefs to mercurial?  I've been
> considering migrating e2fsprogs development to git, but one of the
> reasons I haven't is because I was concerned that might be incovenient
> for you folks.

Not at all, we just generate a 1.39 to 1.39-WIP patch, and then use
quilt + CVS to manage the resulting patches.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
