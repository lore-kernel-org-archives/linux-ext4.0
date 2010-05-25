From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5/8] tracing: Convert more ext4 events to DEFINE_EVENT
Date: Tue, 25 May 2010 11:02:53 -0400
Message-ID: <1274799773.22648.210.camel@gandalf.stny.rr.com>
References: <4BFA3728.3000701@cn.fujitsu.com>
	 <4BFA37A4.1050208@cn.fujitsu.com>  <20100525145756.GJ5556@thunk.org>
Reply-To: rostedt@goodmis.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab0EYPC4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 11:02:56 -0400
In-Reply-To: <20100525145756.GJ5556@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2010-05-25 at 10:57 -0400, tytso@mit.edu wrote:
> On Mon, May 24, 2010 at 04:24:04PM +0800, Li Zefan wrote:
> > Use DECLARE_EVENT_CLASS, and save ~2.7K:
> > 
> >    text    data     bss     dec     hex filename
> >  274441    7200     260  281901   44d2d fs/ext4/ext4.o.orig
> >  271881    7040     256  279177   44289 fs/ext4/ext4.o
> > 
> > 4 events are converted:
> > 
> >   ext4__mb_new_pa: ext4_mb_new_inode_pa, ext4_mb_new_group_pa
> >   ext4__mballoc:   ext4_mballoc_discard, ext4_mballoc_free
> > 
> > No change in functionality.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks, added to the ext4 tree.

You could add...

Acked-by: Steven Rostedt <rostedt@goodmis.org>

if you want.

-- Steve


