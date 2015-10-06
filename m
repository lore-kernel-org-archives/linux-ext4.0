From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Tue, 6 Oct 2015 09:56:52 +0200
Message-ID: <20151006075652.GA11757@gmail.com>
References: <20151005152236.GA8140@thunk.org>
 <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
 <5612A3F3.2040609@linux.intel.com>
 <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
 <B602A991-01B4-42E7-AF13-1E21DFB714F8@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B602A991-01B4-42E7-AF13-1E21DFB714F8@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On October 5, 2015 1:22:44 PM PDT, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > We could probably do them outside the loop, rather than tightly around the 
> > actual move instructions. Peter (hpa), is there some sane interface to try to 
> > do that?
> 
> There are... in particular the get_user_try/catch mechanism, used among other 
> things by the signal handing, as well as the copy functions (I don't have the 
> original code in front of me so I don't have the context which would be 
> appropriate.)

Yes, but note that those interfaces are x86 only at the moment, so they'd have to 
be factored out and generalized before we can use it in generic code.

Thanks,

	Ingo
