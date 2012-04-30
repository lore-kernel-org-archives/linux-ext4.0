From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 15:01:44 -0400
Message-ID: <20120430190144.GB5769@thunk.org>
References: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
 <4F9ECC0E.8020201@redhat.com>
 <x49ty01i0ih.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Daniel Drake <dsd@laptop.org>,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49110 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2D3TB4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 15:01:56 -0400
Content-Disposition: inline
In-Reply-To: <x49ty01i0ih.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 30, 2012 at 01:37:42PM -0400, Jeff Moyer wrote:
> 
> Note that fdisk -u gives sector units, which may or may not be 512
> bytes:
> 
> $ sudo fdisk -lu /dev/sdb
> Note: sector size is 4096 (not 512)

Note: you can also get the same numbers from /proc/partitions.

Regards,

					- Ted
