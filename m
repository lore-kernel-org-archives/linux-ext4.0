From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Tue, 6 Oct 2015 15:42:42 +0200
Message-ID: <20151006134242.GA13181@gmail.com>
References: <20151005152236.GA8140@thunk.org>
 <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
 <5612A3F3.2040609@linux.intel.com>
 <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
 <B602A991-01B4-42E7-AF13-1E21DFB714F8@zytor.com>
 <20151006075652.GA11757@gmail.com>
 <CA+55aFxjcXJ9iaRJpCwsOchbJ5p2ch0zXs5=ywMMOuFUAair1A@mail.gmail.com>
 <20151006092757.GA27419@gmail.com>
 <CA+55aFwYW1q2b5BeRBQRunU_hmB+TbB_Q-kPoSwgyhT20g4-ag@mail.gmail.com>
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
In-Reply-To: <CA+55aFwYW1q2b5BeRBQRunU_hmB+TbB_Q-kPoSwgyhT20g4-ag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Oct 6, 2015 at 10:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >>
> >> We really should try get rid of _all_ uses of the "__" versions unless they are
> >> very locally and obviously checked with access_ok(). We've had way too many
> >> cases where people thought they were clever, and weren't really.
> >
> > That's a good idea.
> >
> > The logistics worries me a bit: it looks like a major undertaking, considering the
> > widespread use of these APIs in 1400+ call sites:
> 
> Well, quite frankly, I think I'd be ok with just a mass conversion of the "__" 
> functions to non-underscore ones.
> 
> From past experience, I don't think we have anything that really cares. The one 
> exception is probably the signal stack handling, because it really uses multiple 
> individual accesses, and so it is much more noticeable.
> 
> And there should be *no* meaningful difference between the underscore version 
> and the non-underscore one, unless somebody does something really odd and 
> questionable (ie depends on a kernel pointer - which doesn't even work on all 
> architectures!).
> 
> So I really think we could do a mass conversion of everything that isn't under 
> "arch/" (and obviously asm-generic/uaccess.h) in just one single go.
> 
> I obviously wouldn't take that into 4.3, but I really don't think this would 
> merit splitting up into multiple patches either.
> 
> Then, one by one, we might convert back to __get/put_user() when we've (a) added 
> the SMAP/PAN infrastructure (b) verified that there's an access_ok() 
> _right_there_ and (c) actually verified that it's performance-critical.
> 
> I see drivers doing __get/put_user(), and it just makes me go "no". Not only are 
> drivers likely to get it wrong, I don't believe the extra couple of cycles is 
> going to matter compared to the cost of the hardware access itself. And if the 
> access_ok() isn't local and obviously in the *only* place that can possibly lead 
> to that code, then the code shouldn't use the underscore versions.

Great, fully agreed and will implement it this way!

Thanks,

	Ingo
