From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] vfs: allow custom EOF in generic_file_llseek code
Date: Mon, 30 Apr 2012 09:17:52 -0500
Message-ID: <4F9E9F10.2060400@sandeen.net>
References: <4F9AC770.8080004@redhat.com> <20120428183315.GA28349@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57742 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2D3ORx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 10:17:53 -0400
In-Reply-To: <20120428183315.GA28349@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/28/12 1:33 PM, Matthew Wilcox wrote:
> On Fri, Apr 27, 2012 at 11:21:04AM -0500, Eric Sandeen wrote:
>> As far as I know, this does not fix any bugs - nfs in the kernel
>> doesn't use SEEK_END, and I don't know of any user who does.  But
>> some ext4 folks seem keen on doing the right thing here, and I can't
>> really argue.
> 
> I like it.  In particular it removes a lot of calls to i_size_read() which
> may have some nice benefits on 32-bit systems.  
> 
> However, there is only one call to generic_file_llseek_size() in the
> kernel (and it's in ext4!)  I would suggest simply changing the prototype
> of generic_file_llseek_size ... or if you insist, just renaming it to
> generic_file_llseek_size_eof().

Ok, if both users are only in ext* you're right, probably no need to have
both variants with 2 kinds of special sauce.  Is it cool to change the
prototype of the existing function, or should I rename it?  I guess since
it'll properly break any current users in obvious ways, I could just
add a new argument to the _size() variant.  I'll send a V2.

Thanks,
-Eric

