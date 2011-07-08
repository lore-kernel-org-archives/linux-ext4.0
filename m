From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/23] ext4: add some tracepoints in ext4/extents.c
Date: Fri, 8 Jul 2011 19:20:10 -0400
Message-ID: <20110708232010.GK3331@thunk.org>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
 <1309970166-11770-24-git-send-email-tytso@mit.edu>
 <CAMUAhYS__oEX025d+a-XS20XshcP8NaF5yjZEsOENJ3nh8oNPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Aditya Kali <adityakali@google.com>
To: Eric Gouriou <egouriou@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49820 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1GHXUM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 19:20:12 -0400
Content-Disposition: inline
In-Reply-To: <CAMUAhYS__oEX025d+a-XS20XshcP8NaF5yjZEsOENJ3nh8oNPg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2011 at 11:12:30AM -0700, Eric Gouriou wrote:
> 
> In all the trace points that capture the logical block/physical
> block/length of an extent, it would be nicer to pass the extent itself
> as a parameter and perform the extraction in the TP_fast_assign()
> block. This requires adding an #include <ext4_extents.h> above the
> include of <trace/trace_events/ext4.h> in fs/ext4/super.c in order to
> have ext4_ext_pblock() and ext4_ext_get_actual_len() available.
> 
> By itself this should not be ground to respin the whole patch series,
> a follow-on cleanup patch would do (I volunteer to create one if
> desired). Fortunately this wouldn't cause the trace record format to
> change, so it wouldn't cause any backward/forward compatibility issue.

Good suggestion, I've made this change.

						- Ted
