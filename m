From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Wed, 27 Mar 2013 15:05:12 -0400
Message-ID: <20130327190512.GA22889@thunk.org>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <5153217B.5070909@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Rich Johnston <rjohnston@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56473 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3C0TFP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 15:05:15 -0400
Content-Disposition: inline
In-Reply-To: <5153217B.5070909@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What do you think about renaming the existing tests from NNN to
NNN-descriptive-name?  That way it will be easier for people who are
trying to track regressions, since they can easily map from the new
more descriptive name to the old test number for comparison purposes
(i.e., to see whether a failure is a regression or not, etc.)

Would you be open to changes which did this?  I'd suggest sending the
changes as a shell script to minimize the chances of patch conflicts.
It will cause people to need to regenerate their patches, but that
means now would be the time to do this, when everyone will need to be
fixing up their outstanding changes anyway.  :-)

       	      	      		- Ted
