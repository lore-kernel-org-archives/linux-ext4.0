From: Theodore Tso <tytso@mit.edu>
Subject: Re: howto downgrade ext4 to ext3
Date: Fri, 18 Sep 2009 15:34:56 -0400
Message-ID: <20090918193456.GA27303@mit.edu>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jehan procaccia <jehan.procaccia@it-sudparis.eu>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58364 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498AbZIRTe5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 15:34:57 -0400
Content-Disposition: inline
In-Reply-To: <4AB3D060.2020101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2009 at 01:24:32PM -0500, Eric Sandeen wrote:
>
> Delalloc should be mostly ok in that kernel, but quota doesn't handle  
> it.  So dropping quota -or- dropping delalloc should suffice.
>
> OTOH, the -o nodelalloc paths have not gotten a lot of test coverage, so  
> caveats apply.

I haven't dont a -o delalloc test in a while, but at one point,
probably about 2-3 months ago, I did do a regression test run using
the xfsqa test suite with -o delalloc.  Of course, just because
mainline -o delalloc has been tested doesn't say that much about RHEL
5.4's -o delalloc --- there's a reason why it was labelled a
Technology Preview on RHEL 5.4.  :-)

						 - Ted
