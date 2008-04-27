From: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sat, 26 Apr 2008 22:00:39 -0300
Message-ID: <20080427010039.GB12370@ghostprotocols.net>
References: <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> <20080425230028.GC31226@Krystal> <481265B7.9040505@goop.org> <48126A80.4000203@redhat.com> <4812CA02.8040705@goop.org> <20080426115634.GH16635@ghostprotocols.net> <4813BCF8.3090907@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,         Masami Hiramatsu <mhiramat@redhat.com>,         Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,         Linus Torvalds <torvalds@linux-foundation.org>,         "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,         Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,         David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,         rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,         linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,         penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,         pageexec@freemail.hu, "Frank Ch. Eigler" <fche@redhat.com>,         systemtap@sources.redhat.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <systemtap-return-8630-gls-systemtap=m.gmane.org@sourceware.org>
Content-Disposition: inline
In-Reply-To: <4813BCF8.3090907@goop.org>
List-Unsubscribe: <mailto:systemtap-unsubscribe-gls-systemtap=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:systemtap-subscribe@sourceware.org>
List-Post: <mailto:systemtap@sourceware.org>
List-Help: <mailto:systemtap-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: systemtap-owner@sourceware.org
List-Id: linux-ext4.vger.kernel.org

Em Sat, Apr 26, 2008 at 04:38:32PM -0700, Jeremy Fitzhardinge escreveu:
> Arnaldo Carvalho de Melo wrote:
>> You do, when you decide to stop tracing. He is not talking about the old
>> function, that one, indeed will always be there, but what about the new
>> one? When tracing stops we want to remove it and revert to using the old
>> one...
>>
>> But perhaps you are suggesting that the new one, once loaded, stays
>> there forever, that would work, but after several tracing sessions one
>> would have to eventually reboot the machine due to many modules left
>> loaded.
>
> As I said, it doesn't seem like a very satisfactory way to solve the 
> problem.

Indeed :-)

- Arnaldo
