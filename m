From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How can I flush all writes before yanking the power cable?
Date: Thu, 7 Feb 2013 15:58:03 -0500
Message-ID: <20130207205803.GB28084@thunk.org>
References: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com>
 <5113EE8F.2080104@redhat.com>
 <CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47310 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3BGU6G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 15:58:06 -0500
Content-Disposition: inline
In-Reply-To: <CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 07, 2013 at 02:37:02PM -0500, Autif Khan wrote:
> 
> That was precisely my ignorance. I did not know about barrier. Adding
> it during mount ro and remount rw seems to have fixed these issues.

You also didn't say what file system you were using.  Was it ext4?
ext3?  ext2?  What kernel version?  On modern kernels barrier is
enabled by default for both ext3 and ext4.

Regards,

						- Ted
