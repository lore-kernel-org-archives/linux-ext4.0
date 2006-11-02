From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4 roadmap
Date: Thu, 2 Nov 2006 09:17:53 +0800
Message-ID: <20061102011753.GM5212@schatzie.adilger.int>
References: <1162422997.13777.35.camel@kleikamp.austin.ibm.com> <Pine.LNX.4.63.0611020026000.14187@alpha.polcom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33997 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1423096AbWKBBSM
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Nov 2006 20:18:12 -0500
To: Grzegorz Kulewski <kangur@polcom.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0611020026000.14187@alpha.polcom.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 02, 2006  00:52 +0100, Grzegorz Kulewski wrote:
> Is there any chance to get compression and/or encryption in ext4?

Note that all of the features mentioned in the list at least have some
kind of prototype already or people working on it.  It isn't really a
"feature request list".  I'm not sure how many people are interested
in compression/encryption, but if they are they should come forward
with a patch.

Note that there was previously a compression patch for ext2, maybe that
could be moved forward for ext4?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
