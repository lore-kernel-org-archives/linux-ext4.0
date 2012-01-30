From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4 Kernel Crash
Date: Mon, 30 Jan 2012 12:26:59 -0500
Message-ID: <20120130172659.GA7681@thunk.org>
References: <20120129175057.GA4699@dinofilaria.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Nanakos Chrysostomos <nanakos@wired-net.gr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58173 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab2A3R1G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 12:27:06 -0500
Content-Disposition: inline
In-Reply-To: <20120129175057.GA4699@dinofilaria.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 29, 2012 at 07:50:57PM +0200, Nanakos Chrysostomos wrote:
> Dear Linux Kernel Developers,
> I am writing to report a kernel or ext4 bug.

Hi Nanakos,

My apologies for not responding to the message that you sent to me
personally three days ago, but I was on vacation in Hawaii; the best
place to send queries about ext4 file systems is to use the
linux-ext4@vger.kernel.org mailing list.

One thing that I would immediately suggest is to see whether you can
reproduce this bug using a modern kernel.  You are currently using a
RHEL6-derived kernel (2.6.32-220.4.1.el6.x86_64).  The ext4 file
system in such a kernel is quite different from what is in upstream,
and there were a large number of bugs that have been fixed in ext4
since 2.6.32.  Many of these fixes were backported into the RHEL6
kernel, but I'm not an expert on which fixes have been backported into
RHEL6 and which haven't.  (Especially since Red Hat doesn't release
broken-out patches for their RHEL kernels....)

My understanding is that Gluster doesn't require any kernel-side
patches, so it should be OK to run Gluster on a v3.2 kernel.
Alternatively, if you are a paid customer of RHEL6, I'd suggest
sending a support request to Red Hat.

Best regards,

					- Ted
