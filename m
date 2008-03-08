From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if
	block
Date: Sat, 8 Mar 2008 11:42:58 -0500
Message-ID: <20080308164258.GA30512@infradead.org>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com> <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com> <20080307212336.GE1881@webber.adilger.int> <20080308150229.GA22430@infradead.org> <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYCHQm7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 11:42:59 -0500
Content-Disposition: inline
In-Reply-To: <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 08, 2008 at 04:40:46PM +0000, Duane Griffin wrote:
> > That doesn't make any sense.  They're initialized in module_init and
> >  destoryed in module_exit.  They can never be zero at journal_load time
> >  unless you get random memory corruption overwriting exactly that pointer
> >  with zero.
> 
> If jbd is a module, sure, but not if it is statically linked in. I
> have the stacktraces to prove it :)

That text above was in reply to Andreas comment about checking it in
journal_load.  Your fix obviously does make sense althrough doing it
differently as in my reply to your first series would be even better.
