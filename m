From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support for
 Ext4
Date: Sun, 25 Feb 2007 02:33:56 -0800
Message-ID: <20070225023356.ecd53f65.akpm@linux-foundation.org>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1>
	<1170263470.12392.23.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: harry@cs.sunysb.edu, linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu,
	kolya@cs.sunysb.edu
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933692AbXBYKeQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Feb 2007 05:34:16 -0500
In-Reply-To: <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 31 Jan 2007 11:11:10 -0600 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> Have you considered putting ALL of the function in the vfs layer?

Yes, I think that's where it should be implemented.

I suspect we'll run into problems with the .trash/<uid> thing.  What directory
do we put .trash in?  The top-level of the mountpoint?   The user might not
be able to access that if he's in a chroot.  And UIDs are now per-nsproxy
things - UIDs are already per-uid-namespace things. So we can have two or more
different users using UID 42.

It all need to be thrashed out with the containerisation and VFS guys.
