From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2image: add -a switch to include all data
Date: Fri, 17 Feb 2012 09:50:25 -0500
Message-ID: <20120217145025.GC19606@thunk.org>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
 <1329428112-8911-2-git-send-email-psusi@ubuntu.com>
 <20120216231745.GC26473@thunk.org>
 <4F3D9CB3.4020704@ubuntu.com>
 <alpine.LFD.2.00.1202171006380.6479@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44491 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2BQOu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 09:50:29 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1202171006380.6479@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 17, 2012 at 10:17:43AM +0100, Lukas Czerner wrote:
> 
> So the problem actually is that I have made some assumptions, like for
> example that all data are laid out sequentially (because it is how we
> are creating the qcow2 images with e2image) and possibly more. 

So if your code doesn't work correctly if the block numbers are
monotonically increasing in the qcow2 image, I would *have* to assume
there would be plenty of qemu-generated images files that don't have
this constraint (i.e., suppose you write blocks 10000, 42, 16, and 24
while running under qemu, presumably that is the order the blocks
would be written and would show up in the qcow2 file).

Or am I misunderstanding what you are saying here; is it that you are
fairly sure the code will break if the data is not laid out
sequentially, or that you've never tested this case?

Regards,

						- Ted
