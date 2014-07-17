From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
Date: Thu, 17 Jul 2014 09:37:55 -0400
Message-ID: <20140717133755.GN1491@thunk.org>
References: <53C687B1.30809@free.fr>
 <21446.38705.190786.631403@quad.stoffel.home>
 <53C6B38A.3000100@free.fr>
 <59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca>
 <53C7A5CA.4050903@free.fr>
 <alpine.LFD.2.00.1407171238060.2312@localhost.localdomain>
 <53C7B0B7.9030007@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mason <mpeg.blue@free.fr>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53C7B0B7.9030007@free.fr>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 17, 2014 at 01:17:11PM +0200, Mason wrote:
> unlink("/mnt/hdd/xxx")                  = 0 <111.479283>
> 
> 0.01user 111.48system 1:51.99elapsed 99%CPU (0avgtext+0avgdata 772maxresident)k
> 0inputs+0outputs (0major+434minor)pagefaults 0swaps

... and we're CPU bound inside the kernel.

Can you run perf so we can see exactly where we're spending the CPU?
You're not using a journal, so I'm pretty sure what you will find is
that we're spending all of our time in mb_free_blocks(), when it is
updating the internal mballoc buddy bitmaps.

With a journal, this work done by mb_free_blocks() is hidden in the
kjournal thread, and happens after the commit is completed, so it
won't block other file system operations (other than burning some
extra CPU on one of the multiple cores available on a typical x86
CPU).

Also, I suspect the CPU overhead is *much* less on an x86 CPU, which
has native bit test/set/clear instructions, whereas the MIPS
architecture was designed by Prof. Hennessy at Stanford, who was a
doctrinaire RISC fanatic, so there would be no bitop instructions.

Even though I'm pretty sure what we'll find, knowing exactly *where*
in mb_free_blocks() or the function it calls would be helpful in
knowing what we need to optimize.  So if you could try using perf
(assuming that the perf is supported MIPS; not sure if it does) that
would be really helpful.

Thanks,

					- Ted
