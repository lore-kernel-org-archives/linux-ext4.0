From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: cleaned up ext4 patch series
Date: Mon, 19 Mar 2007 11:31:22 -0600
Message-ID: <20070319173122.GC5967@schatzie.adilger.int>
References: <1174319308.11636.8.camel@kleikamp.austin.ibm.com> <1174324522.11657.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52326 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966032AbXCSRbY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2007 13:31:24 -0400
Content-Disposition: inline
In-Reply-To: <1174324522.11657.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 19, 2007  09:15 -0800, Mingming Cao wrote:
> I wonder if we should create two branches: one branch for patches that
> are well discussed and tested, which Andrew could trust and pull to mm
> tree; and create another branch to store patches that are still under
> discussion and likely to be rewriten based on the review feedback.

Yes, that makes a lot of sense.  It would avoid issues like Andrew finding
problems with the nanosecond patches because they hadn't been widely tested
yet.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
