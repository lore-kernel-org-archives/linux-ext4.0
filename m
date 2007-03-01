From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 22:58:55 +0000
Message-ID: <20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<45E74238.3040606@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49403 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030365AbXCAV4g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2007 16:56:36 -0500
In-Reply-To: <45E74238.3040606@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 01 Mar 2007 13:14:32 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Amit K. Arora wrote:
> > +	if (inode->i_op && inode->i_op->fallocate)
> > +		ret = inode->i_op->fallocate(inode, offset, len);
> > +	else
> > +		ret = -ENOTTY;
> 
> You can only allocate space on typewriters? ;)

A lot of people get confused about -ENOTTY, but it is the return for
attempting to use an ioctl on the wrong type of object, so this appears
to be quite correct.
