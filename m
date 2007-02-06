From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Mon, 5 Feb 2007 22:48:53 -0500
Message-ID: <20070206034853.GD11018@thunk.org>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1> <1170263470.12392.23.camel@kleikamp.austin.ibm.com> <Pine.GSO.4.53.0702011200340.9072@compserv1> <1170358339.12263.39.camel@kleikamp.austin.ibm.com> <1170362491.4271.31.camel@localhost.localdomain> <20070202014004.GB24328@mail.clusterfs.com> <1170382948.18617.30.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Dave Kleikamp <shaggy@linux.external-vnet.ibm.com>,
	Nikolai Joukov <kolya@cs.sunysb.edu>,
	Harry Papaxenopoulos <harry@cs.sunysb.edu>,
	linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46382 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965310AbXBFFyz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Feb 2007 00:54:55 -0500
Content-Disposition: inline
In-Reply-To: <1170382948.18617.30.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 01, 2007 at 08:22:28PM -0600, Dave Kleikamp wrote:
> Al Viro will love that one.  :-)
> 
> Another idea might be to store those attribute flags in the generic
> inode.

Yeah, that's really the right answer.  Having a common way of storing
attributes in struct kstat (and notified via struct iattr and
notify_change) is the right way for us to store some of these
filesystem-common flags, and would make a huge amount of sense.

I don't really view ths secure deletion and trash-bin support as
really being an ext4 feature, but really a generic feature which can
enhance multiple filesystems *including* ext4.  So it would be really
good idea to give these patches an airing on linux-fsdevel and
linux-kernel.

Regards,

						- Ted
