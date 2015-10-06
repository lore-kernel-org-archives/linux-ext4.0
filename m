From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Tue, 6 Oct 2015 11:27:57 +0200
Message-ID: <20151006092757.GA27419@gmail.com>
References: <20151005152236.GA8140@thunk.org>
 <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
 <5612A3F3.2040609@linux.intel.com>
 <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
 <B602A991-01B4-42E7-AF13-1E21DFB714F8@zytor.com>
 <20151006075652.GA11757@gmail.com>
 <CA+55aFxjcXJ9iaRJpCwsOchbJ5p2ch0zXs5=ywMMOuFUAair1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxjcXJ9iaRJpCwsOchbJ5p2ch0zXs5=ywMMOuFUAair1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Oct 6, 2015 at 8:56 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Yes, but note that those interfaces are x86 only at the moment, so they'd have 
> > to be factored out and generalized before we can use it in generic code.
> 
> ARM64 these days (as a part of ARM8.1) has "Privileged Access Never", which is 
> their name for SMAP. They do it somewhat similarly with an instruction to 
> clear/set the PAN bit in the pstate register.
> 
> So we really should strive to make this support generic, because by now it's not 
> x86-specific, and x86 and ARM64 together aren't exactly some odd special case..

Absolutely.

> I do in fact wonder if we should aim (eventually) for the rule that the "__" 
> versions of the user access functions should not do the SMAP/PAN thing, since 
> they have to be explicitly checked for pointer being valid anyway. And just make 
> the rule be that since you have to check for the pointer being valid, you might 
> as well also have to do the SMAP/PAN thing too.
> 
> We really should try get rid of _all_ uses of the "__" versions unless they are 
> very locally and obviously checked with access_ok(). We've had way too many 
> cases where people thought they were clever, and weren't really.

That's a good idea.

The logistics worries me a bit: it looks like a major undertaking, considering the 
widespread use of these APIs in 1400+ call sites:

  triton:~/tip> git grep -E '__get_user|__put_user' | grep -vE '\.h:|arch/' | wc -l
  1086
  triton:~/tip> git grep -E '__get_user|__put_user' arch/x86/ arch/arm64/ | wc -l
  354

... affecting 93 files:

  triton:~/tip> git grep -lE '__get_user|__put_user' | grep -vE '\.h:|arch/' | wc -l
  70
  triton:~/tip> git grep -lE '__get_user|__put_user' arch/x86/ arch/arm64/ | wc -l
  23

(Assuming my grep-fu is strong enough.)

Which is probably more than a hundred commits until we get rid of all 
double-underscore uses?

Thanks,

	Ingo
