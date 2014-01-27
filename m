From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v5 10/22] Remove get_xip_mem
Date: Mon, 27 Jan 2014 06:26:45 -0700
Message-ID: <20140127132644.GB20939@parisc-linux.org>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com> <557203b474f633a59f32fee1f624a5239effcab7.1389779961.git.matthew.r.wilcox@intel.com> <52D739F4.8060108@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60157 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaA0N0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jan 2014 08:26:49 -0500
Content-Disposition: inline
In-Reply-To: <52D739F4.8060108@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 05:46:28PM -0800, Randy Dunlap wrote:
> > +In order to support this method, the storage must be byte-accessable by
> 
>                                                         byte-accessible

Thanks.  Fixed.

> > +- ensuring that there is sufficient locking between reads, writes,
> > +  truncates and page faults
> 
>      truncates, and
> but that's up to you and your editor/proofreader etc.  :)

Ooh, do we really get to have a discussion about the Oxford Comma on
linux-kernel?  :-)

I haven't actually run this material past my editor (who is my wife, so
I need really convincing arguments to do it your way instead of hers),
but funnily we had a conversation about the Oxford Comma while on holiday
last week.  http://en.wikipedia.org/wiki/Serial_comma has a reasonably
exhaustive discourse on the subject, and I learned that she's probably
primarily against it because of her journalism degree.

> > +Even if the kernel or its modules are stored on an filesystem that supports
> 
>                                                    a

Good catch.  I think I started out with 'an fs', then expanded it to
"an filesystem" which of course is nonsense.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
