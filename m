From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsck and human intervention
Date: Wed, 7 Mar 2007 13:19:13 +0800
Message-ID: <20070307051913.GF5723@schatzie.adilger.int>
References: <1173112017.6300.14.camel@systems03.mmm.com> <20070306024024.GZ6662@schatzie.adilger.int> <1173191227.11804.9.camel@systems03.mmm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <ddrake@brontes3d.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45716 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbXCGFTR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2007 00:19:17 -0500
Content-Disposition: inline
In-Reply-To: <1173191227.11804.9.camel@systems03.mmm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 06, 2007  09:27 -0500, Daniel Drake wrote:
> OK. Given that write caching may be required for performance reasons or
> there might be other possible reasons which would result in
> preen-unrepairable fs corruption on power loss, my question is now: Is
> it a really bad idea to run "e2fsck -y" on every boot?

If your primary concern is not halting the boot, then yes.  99% of people
only know to answer "y" to e2fsck anyways.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
