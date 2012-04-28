From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] vfs: allow custom EOF in generic_file_llseek code
Date: Sat, 28 Apr 2012 12:33:15 -0600
Message-ID: <20120428183315.GA28349@parisc-linux.org>
References: <4F9AC770.8080004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36584 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2D1SdR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Apr 2012 14:33:17 -0400
Content-Disposition: inline
In-Reply-To: <4F9AC770.8080004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 27, 2012 at 11:21:04AM -0500, Eric Sandeen wrote:
> As far as I know, this does not fix any bugs - nfs in the kernel
> doesn't use SEEK_END, and I don't know of any user who does.  But
> some ext4 folks seem keen on doing the right thing here, and I can't
> really argue.

I like it.  In particular it removes a lot of calls to i_size_read() which
may have some nice benefits on 32-bit systems.  

However, there is only one call to generic_file_llseek_size() in the
kernel (and it's in ext4!)  I would suggest simply changing the prototype
of generic_file_llseek_size ... or if you insist, just renaming it to
generic_file_llseek_size_eof().

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
