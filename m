From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
Date: Mon, 6 Oct 2008 18:04:29 -0700
Message-ID: <20081007010429.GF26632@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com> <20081006214251.GB26632@mail.oracle.com> <20081006233248.GA9337@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:30461 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbYJGBFf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 21:05:35 -0400
Content-Disposition: inline
In-Reply-To: <20081006233248.GA9337@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 07:32:48PM -0400, Theodore Tso wrote:
> pieces work.  Andrew Morton is right; Stephen Tweedie wrote some
> *very* clever code

	sct is very good at doing that, and even better at going off
afterwards :-)

> it all works.  So I suspect one of is going to have take a deep dive
> into the code, grok how the trifecta of b_committed_data,
> b_frozen_data, and b_data interact, and which functions make what
> assumptions, and then write up a lot of explanatory documentation....
> 
> Unfortunately, I'm not sure I'm going to have time for at least the
> next couple of weeks.  Do you think you could take a crack at it?

	I think I just did some of it in the previous email, so I
suppose I should do some more.  Let me see if I can squeeze it in.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
