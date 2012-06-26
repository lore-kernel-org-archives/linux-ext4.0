From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 14:59:49 -0400
Message-ID: <20120626185949.GB26669@thunk.org>
References: <4FE8086F.4070506@zoho.com>
 <20120625085159.GA18931@gmail.com>
 <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Fredrick <fjohnber@zoho.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52859 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab2FZS7v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 14:59:51 -0400
Content-Disposition: inline
In-Reply-To: <4FE9F9F4.7010804@zoho.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:05:40AM -0700, Fredrick wrote:
> 
> I had run perf stat on ext4 functions between two runs of our program
> writing data to a file for the first time and writing data to the file
> for the second time(where the extents are initialized).

>From your mballoc differences, it sounds like you were comparing
fallocate with not using fallocate at all; is that right?

The comparison you need to do is using normal fallocate versus
fallocate with the no-hide-stale feature enabled.  It's obvious that
allocating blocks as you need will always be more expensive than using
fallocate.

						- Ted
