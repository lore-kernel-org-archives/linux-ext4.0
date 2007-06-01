From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 1 Jun 2007 12:56:45 +0200
Message-ID: <20070601105645.GD7217@one.firstfloor.org>
References: <1179777153.3910.13.camel@garfield> <p731wgwcbac.fsf@bingen.suse.de> <20070601091435.GR5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:53001 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbXFAK4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 06:56:47 -0400
Content-Disposition: inline
In-Reply-To: <20070601091435.GR5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> It was mentioned before but deserves mentioning again that this will
> be an optional feature, mostly for use on SANs, iSCSI, etc where a disk
> might be accessed by multiple nodes at the same time.  That means there
> will not be any impact for desktop users waiting 10s for each of their
> filesystems to mount.

A safety feature that is optional? Doesn't sound very safe to me.
If the safety is needed it should be probably default, otherwise
it isn't needed.

-Andi
