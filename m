From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 12:36:33 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com>
References: <20080425.021301.193689806.davem@davemloft.net>
 <1209343883-7991-1-git-send-email-jirislaby@gmail.com>
 <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
 <20080425151747.GA3265@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:36093 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbYDYTgf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 15:36:35 -0400
In-Reply-To: <20080425151747.GA3265@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 25 Apr 2008, Andi Kleen wrote:

> > And we should really add a lot more sanity checking there.
> 
> A debug mode for virt_to_page(),__pa,__va et.al. would probably make sense
> and would have caught it.
> 
> I used to have that partly in the x86-64 port with VIRTUAL_BUG_ON.

Good idea! Do you have a patch?

