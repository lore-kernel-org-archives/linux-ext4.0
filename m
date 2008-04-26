From: fche@redhat.com (Frank Ch. Eigler)
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 22:12:33 -0400
Message-ID: <y0my771fjou.fsf@ton.toronto.redhat.com>
References: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org>
	<20080425161916.GD3265@one.firstfloor.org>
	<20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com>
	<20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal>
	<48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal>
	<481241DC.3070601@zytor.com>
	<alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org>
	<20080425211205.GC25950@Krystal>
	<alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbYDZCSj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 22:18:39 -0400
In-Reply-To: <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> (Linus Torvalds's message of "Fri, 25 Apr 2008 15:04:51 -0700 (PDT)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> [...]
>> The point is to provide a way to dynamically enable code at runtime
>> without noticeable performance impact on the system.
>
> Quite frankly, maybe I'm a bit dense, but why don't you just recompile the 
> whole original function (at run-time), load that new version of a function 
> as a mini-module, and then insert a marker at the top of the old function 
> that just does a "jmp replacementfunction". [...]

You mentioned possible solutions to some of the problems this
ambitious an approach would cause.  Here are a few more complications:

- instrumenting inlined functions

- proper sharing of static function data amongst multiple live
  copies of same function

- unknown implications of violating long-standing assumptions about
  functions not changing addresses

- interaction with other code modification machinery (kprobes, ...)

- necessity to carry kernel sources & compilers on machines; slow
  marker activation


- FChE
