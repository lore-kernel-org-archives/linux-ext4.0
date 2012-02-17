From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] e2image: add -a switch to include all data
Date: Fri, 17 Feb 2012 16:35:20 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202171630130.5649@dhcp-27-109.brq.redhat.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com> <1329428112-8911-2-git-send-email-psusi@ubuntu.com> <20120216231745.GC26473@thunk.org> <4F3D9CB3.4020704@ubuntu.com> <alpine.LFD.2.00.1202171006380.6479@dhcp-27-109.brq.redhat.com>
 <20120217145025.GC19606@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab2BQPf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 10:35:27 -0500
In-Reply-To: <20120217145025.GC19606@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Feb 2012, Ted Ts'o wrote:

> On Fri, Feb 17, 2012 at 10:17:43AM +0100, Lukas Czerner wrote:
> > 
> > So the problem actually is that I have made some assumptions, like for
> > example that all data are laid out sequentially (because it is how we
> > are creating the qcow2 images with e2image) and possibly more. 
> 
> So if your code doesn't work correctly if the block numbers are
> monotonically increasing in the qcow2 image, I would *have* to assume
> there would be plenty of qemu-generated images files that don't have
> this constraint (i.e., suppose you write blocks 10000, 42, 16, and 24
> while running under qemu, presumably that is the order the blocks
> would be written and would show up in the qcow2 file).
> 
> Or am I misunderstanding what you are saying here; is it that you are
> fairly sure the code will break if the data is not laid out
> sequentially, or that you've never tested this case?

Hi Ted,

as I said I have never tested this. Well, actually I did some very
limited testing, but since this was not (and still is not right?) the
scope of e2image I did not care enough to test that extensively enough
to be sure that it generally works with qcow2 images other than those
generated with e2image. But I think it should work.

Also I suppose that qemu is being a bit smarter than just writing every
extent out so it does not seek madly back and forth when the image is
not laid out sequentially. e2image does not do that.

Thanks!
-Lukas

> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
