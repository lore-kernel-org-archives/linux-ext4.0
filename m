From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Tue, 11 Sep 2012 14:06:46 -0400
Message-ID: <20120911180646.GC763@thunk.org>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
 <20120910024709.GA3439@thunk.org>
 <CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com>
 <CAHSRzpDATS+yMDyw6Wts2DMjyDpJx0rVB5M8QLpKxPFUwHWzXA@mail.gmail.com>
 <CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com>
 <CAHSRzpC1SKr08yS0EvEAkS4JpoiAfZ0ab+PHkZwED02mrVbc-A@mail.gmail.com>
 <CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com>
 <20120911170041.GB763@thunk.org>
 <CAHSRzpCFs1GdcMkNcXpoN0Q5MnGwQuonETTv8k9kELZwSe=sWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Terry <td3201@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50106 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab2IKSGt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2012 14:06:49 -0400
Content-Disposition: inline
In-Reply-To: <CAHSRzpCFs1GdcMkNcXpoN0Q5MnGwQuonETTv8k9kELZwSe=sWw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 11, 2012 at 12:07:14PM -0500, Terry wrote:
> 
> RHEL 6.3 with kernel 2.6.32-279.5.2.el6.x86_64

I'll let Eric or Lukas comment, but as far as I know the ext4 in the
RHEL 6 kernels has been quite stable (there are a lot of bug fixes
that have been backported to the RHEL 6 kernel, and while it doesn't
have some of the newer ext4 features, it doesn't have any of the more
exciting bugs that might come with the newer features :-).

So I really would strongly suspect the SAN or the SAN-attached storage
as being flaky, causing the file system corruptions which is leading
to the kernel and e2fsck complaining.

Regards,

						- Ted



