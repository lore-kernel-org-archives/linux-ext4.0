From: Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
 all .data.* sections on X86_64)
Date: Sat, 18 Jul 2009 15:30:01 +0200
Message-ID: <4A61CE59.3030905@fisher-privat.net>
References: <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com> <4A5C41C8.7040904@fisher-privat.net> <1247564356.28240.30.camel@pc1117.cambridge.arm.com> <1247565175.28240.37.camel@pc1117.cambridge.arm.com> <4A5C5A59.5080304@fisher-privat.net> <1247567499.28240.48.camel@pc1117.cambridge.arm.com> <4A5C5FD0.3020204@fisher-privat.net> <1247574390.28240.67.camel@pc1117.cambridge.arm.com> <20090715080336.GA4823@skywalker> <4A5D9939.3000500@fisher-privat.net> <20090718115556.GA31007@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
	Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>,
	Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090718115556.GA31007-X9Un+BFzKDI@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Ingo Molnar schrieb:
> * Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org> wrote:
> 
>> This patch work for me.
> 
> nice. Any leftovers that might be false positives and need 
> annotation?
> 
> We learned this with lockdep: the moment a typical x86 distro bootup 
> is 'warnings free', utility of the debugging facility increases 
> dramatically: people can standardize on 'kmemleak should never 
> produce warnings' workflows and distros can also start feeding 
> kmemleak reports into kerneloops.org or so.
> 
> So the general direction kmemleak is moving into is really 
> encouraging.
> 
> 	Ingo

suddenly my kernel is not warning free... i have still warning about 
acpi_init, cpufreg, intel_gem and inoitfy on my PC and about firmware 
loader on my laptop. So i think there is still some job to do. I will 
report this warnings soon.
