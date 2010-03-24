From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 11:30:39 -0500
Message-ID: <4BAA3E2F.6030901@redhat.com>
References: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com> <20100324161201.GG2159@thunk.org> <4BAA3C27.2000505@redhat.com> <20100324162747.GI2159@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0CXQan (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 12:30:43 -0400
In-Reply-To: <20100324162747.GI2159@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/24/2010 11:27 AM, tytso@mit.edu wrote:
> On Wed, Mar 24, 2010 at 11:21:59AM -0500, Eric Sandeen wrote:

...

>> so, if you turn off ext2, but leave ext3 on, it will ask you if you want
>> to use ext4 for ext3?  That doesn't make sense to me.
> 
> Well, the idea is you can use ext4 instead of ext2 or ext3.  So if
> ext3 is turned on, but ext2 is off, then the option will use ext4 for
> ext2, but ext3 will stay ext3.

Oh, ok, I shoulda looked at super.c.  Got it now.  :)

Thanks,
-Eric
