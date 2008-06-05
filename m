From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
	buffers
Date: Thu, 5 Jun 2008 10:29:48 -0400
Message-ID: <20080605142948.GA25477@mit.edu>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com> <20080603153050.fb99ac8a.akpm@linux-foundation.org> <20080604101925.GB16572@duck.suse.cz> <20080604111911.c1fe09c6.akpm@linux-foundation.org> <20080604212202.GA8727@mit.edu> <20080604145848.e3da6f20.akpm@linux-foundation.org> <20080604225155.GB8727@mit.edu> <20080605093536.GE27370@duck.suse.cz> <4847CF07.1020904@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	sct@redhat.com, adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35009 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755326AbYFEOaH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 10:30:07 -0400
Content-Disposition: inline
In-Reply-To: <4847CF07.1020904@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 08:33:27PM +0900, Hidehiro Kawai wrote:
> 
> My patch doesn't change the policy.  JBD aborts the journal when
> it detects I/O error in file data since 2.6.11.  Perhaps this patch:
> http://marc.info/?l=linux-kernel&m=110483888632225
> I just added missing error checkings.
> 

Looking at the code paths touched by patch you referenced, you are
correct.  And Andrew even signed off on it.  :-)

But if someone was only examining the patch, it wasn't obvious that
the journal was getting aborted when the JBD layer was forcing buffers
from t_sync_datalist to disk.  So I suspect the change went in without
proper consideration of the net effect.  You just called it out
explicitly in the subject line, which caused Andrew to ask some good
questions; questions that weren't asked in 2005.

> I agree.  I understood that there is a case where we don't want to
> make the fs read-only when writing file data failed.  OTOH there are
> people who want to make the fs read-only to avoid the damage from
> expanding.  Introducing the tunable would be better.
> I'm going to send a patch to make this behavior tunable if some of you
> agree on this way.

Note that doing this right may be tricky, since in the case where we
aren't aborting the journal, we need to set the appropriate flags in
the page cache so that when the user calls fsync() or close(), that
they get the EIO error.

						- Ted
