From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sat, 26 Apr 2008 16:38:32 -0700
Message-ID: <4813BCF8.3090907@goop.org>
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> <20080425230028.GC31226@Krystal> <481265B7.9040505@goop.org> <48126A80.4000203@redhat.com> <4812CA02.8040705@goop.org> <20080426115634.GH16635@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Linus Tor
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:40412 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYDZXin (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2008 19:38:43 -0400
In-Reply-To: <20080426115634.GH16635@ghostprotocols.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arnaldo Carvalho de Melo wrote:
> You do, when you decide to stop tracing. He is not talking about the old
> function, that one, indeed will always be there, but what about the new
> one? When tracing stops we want to remove it and revert to using the old
> one...
>
> But perhaps you are suggesting that the new one, once loaded, stays
> there forever, that would work, but after several tracing sessions one
> would have to eventually reboot the machine due to many modules left
> loaded.

As I said, it doesn't seem like a very satisfactory way to solve the 
problem.

    J

