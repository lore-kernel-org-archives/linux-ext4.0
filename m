From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Take 2]e2fsprogs: Undo I/O manager
Date: Thu, 19 Jul 2007 17:20:27 -0400
Message-ID: <20070719212027.GB26752@thunk.org>
References: <11848678881380-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56628 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761882AbXGSVUa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2007 17:20:30 -0400
Content-Disposition: inline
In-Reply-To: <11848678881380-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 19, 2007 at 11:28:06PM +0530, Aneesh Kumar K.V wrote:
> This patch fixes some bugs found during testing of the large
> inode migration patches.

How are you testing it?  I notice you haven't wired these into any of
the existing e2fsprogs programs.

Regards,

						- Ted
