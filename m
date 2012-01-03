From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND] ext4: add new online resize
Date: Tue, 3 Jan 2012 15:50:48 -0500
Message-ID: <20120103205048.GD30502@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <9CB90BD7-CB4D-42D5-9254-A0455ADB0E15@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36854 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2ADDtd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:33 -0500
Content-Disposition: inline
In-Reply-To: <9CB90BD7-CB4D-42D5-9254-A0455ADB0E15@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 31, 2011 at 10:40:24AM -0700, Andreas Dilger wrote:
> The main issue I have with this patch is that the series starts by
> adding a bunch of unused functions, and only wires them I to the
> existing resize code at the very end.
> 
> A better approach would be to have the early patches refactor the
> existing functions so that they are used by the current resize code,
> and the new resize functionality is enabled at the end.
> 
> That allows verifying that the existing code continues to work
> through the entire series, and that the functions being added
> actually work properly even before the new ioctl is added.

I agree with Andreas that in general this is better way to ago,
although as long as regression testing is done with both the new
(v1.42) resize2fs as well as the old (v1.41.x) resize2fs, it's OK.
(Regressions with the v1.41.x resize2fs are just as important because
many people will be upgrading to the new kernel without necessarily
upgrading their e2fsprogs userspace programs, and we can't let them
break.)

I've done some quick regression testing using both the old and new
resize2fs programs, however, and it looks good.  I'm going to take a
quick final scan over the patches, but I think they are ready for
inclusion.

						- Ted
