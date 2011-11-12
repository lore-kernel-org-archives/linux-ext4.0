From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] e2fsprogs: fix mmp tests on hard 4k devices
 (resend)
Date: Fri, 11 Nov 2011 21:13:18 -0500
Message-ID: <20111112021318.GF4055@thunk.org>
References: <4EBC5524.3000105@redhat.com>
 <4EBC5860.60901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35113 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1KLFQM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Nov 2011 00:16:12 -0500
Content-Disposition: inline
In-Reply-To: <4EBC5860.60901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2011 at 05:04:00PM -0600, Eric Sandeen wrote:
> Several of the mmp tests were failing on an s390 guest because
> direct IO cannot be done on sub-sector sizes, and they were
> doing 1k IOs to files on a 4k logical/physical device.
> 
> A few tests could just be changed to 4k, but others
> needed fixed up output as well.
> 
> With this I have all tests passing on s390 again.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
