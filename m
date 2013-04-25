From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: WARNING: at fs/ext4/inode.c:3222
Date: Thu, 25 Apr 2013 00:24:05 -0400
Message-ID: <20130425042405.GB4685@thunk.org>
References: <84952911.2068510.1366860446300.JavaMail.root@redhat.com>
 <825854245.2071098.1366861400988.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	Steve Best <sbest@redhat.com>
To: CAI Qian <caiqian@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44392 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab3DYEYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Apr 2013 00:24:09 -0400
Content-Disposition: inline
In-Reply-To: <825854245.2071098.1366861400988.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 24, 2013 at 11:43:20PM -0400, CAI Qian wrote: 
> OK, this is to test the latest ext4 dev tree on power 7 systems
> running xfstests,

Thanks for reporting this.  Was this warning thrown while xfstests 224
was running?  (I like to make sure the xfstests output is sent to the
console so the kernel messages are intermixed with the xfstests
output, so it's clear which test triggered the warning.)

If so, can you reproduce the problem running xfstest #224 all by
itself?

Thanks,

						- Ted
