From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 0/13] Patches for e2fsprogs
Date: Tue, 24 Jul 2007 13:25:52 -0400
Message-ID: <20070724172552.GH11826@thunk.org>
References: <1185275071.3789.65.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48479 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbXGXRZ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 13:25:56 -0400
Content-Disposition: inline
In-Reply-To: <1185275071.3789.65.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:34:31PM +0530, Girish Shilamkar wrote:
> Hi,
> 	I am sending the patches for e2fsprogs as decided in the ext4 conf
> call.
> The patches are based on e2fsprogs-1.40.1. Some of these patches have
> already been sent on the list before.

One other minor thing; it would be greatly appreciated it if when
folks send multiple patches in a bundle by having all of the patches
be a reply to the an introductory message.  i.e.:

[Patch 0/13] Patches for e2fsprogs
  |---> [Patch 1/13] iostats.
  |---> [Patch 2/13] Cleanup.
  |---> [Patch 3/13] Rpm Check.
  |---> [Patch 4/14] Allow regular files to be preallocated on-disk.

This makes it easier to make sure the patches stay together in mail
readers even when there are replies to the patches.  It just makes
life a little easier for people going through mail archives.

Thanks!!

						- Ted
