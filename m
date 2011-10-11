From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] ext4: fix possible overflow in ext4_trim_fs()
Date: Tue, 11 Oct 2011 10:13:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110111011230.5752@dhcp-27-109.brq.redhat.com>
References: <1315410777-24237-1-git-send-email-lczerner@redhat.com> <20111010164711.GW7948@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tm@tao.ma
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab1JKINH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Oct 2011 04:13:07 -0400
In-Reply-To: <20111010164711.GW7948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Oct 2011, Ted Ts'o wrote:

> On Wed, Sep 07, 2011 at 05:52:57PM +0200, Lukas Czerner wrote:
> > The overflow can happen when we are calling get_group_no_and_offset()
> > which stores the result of do_div() in 32 bit long type. However the
> > result might be bigger than that if big blocknr is passed in. This will
> > most likely happen when calling FITRIM with the default argument len =
> > ULLONG_MAX.
> > 
> > Fix this by using "end" variable instead of "start+len" as it is easier
> > to get right and specifically check that the end is not beyond the end
> > of the file system, so we are sure that the result of
> > get_group_no_and_offset() will not overflow. Otherwise truncate it to
> > the size of the file system.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Hi Lukas,
> 
> Since I've merged the bigalloc patches that uses clusters instead of
> blocks for various file system parameters.  I made a quick attempt to
> port your patch, and it wasn't obvious (and I don't have your testing
> framework).  Could you do me a favor and forward port your patch to
> either the dev or master branch on the ext4 github repository?
> 
> Thanks!!
> 
> 					- Ted

Hi Ted,

no problem, I'll do that. Btw, the test case for it is already in
xfstests (260) so I'll mention that in the commit description as well.

Thanks!
-Lukas
