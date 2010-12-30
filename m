From: Neil Brown <neilb@suse.de>
Subject: Re: Atomic non-durable file write API
Date: Thu, 30 Dec 2010 11:50:12 +1100
Message-ID: <20101230115012.07fa8ec8@notabene.brown>
References: <20101224095105.GG12763@thunk.org>
	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
	<20101226221016.GF2595@thunk.org>
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
	<20101229075928.6bdafb08@notabene.brown>
	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
	<20101229093158.2bfed8ca@notabene.brown>
	<AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
	<4D1B542B.9030400@ontolinux.com>
	<AANLkTimpsDAUt6KnE=qmcbRLdZdaSaqxvJFh0Ki3iV7B@mail.gmail.com>
	<4D1B621B.5000804@ontolinux.com>
	<AANLkTindNuT0EKkMW1e8syPLEr_j3zRFS++otMQp42B9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTindNuT0EKkMW1e8syPLEr_j3zRFS++otMQp42B9@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 29 Dec 2010 18:14:04 +0100 Olaf van der Spek <olafvdspek@gmail.com>
wrote:

> On Wed, Dec 29, 2010 at 5:30 PM, Christian Stroetmann
> <stroetmann@ontolinux.com> wrote:
> >> Additional steps compared to what? The temp file, fsync, rename case?
> >
> > read the paragraphs as a whole
> 
> Reading stuff again isn't going to change my question.
> 

OK, the fun I over.  I guess it is time to actually answer your question,
rather than just teasing you with partial answers and hints about performance
impact ....

Your question, as I understand it is:

   You see a hypothetical problem for which you cannot see a solution in
   Linux, but for which you also cannot present a concrete use-case where
   this problem needs to be addresses.
   You want to know what the recommended solution is.


   The reality is that the solution was devises and implemented many years ago
   and is deeply embedded in the core design principles of Unix and Linux.
   The reason that you cannot present a use-case is that there isn't one.
   Unix was design so that this hypothetical need will never arise.

   There is a strong parallel with computer viruses.  You could say "viruses
   could be a problem, and while I cannot actually present one that is a
   problem, I want to know what the recommended solution to viruses is"
   The answer is, of course, that Unix/Linux is largely immune to viruses,
   not because of any specific anti-virus feature that was designed and
   implemented, but because the over-all design approach of Unix makes
   viruses hard to spread and rather ineffectual if one ever did take hold.

At least, I think that is the correct answer.  However if you actually have
a concrete use-case, then maybe there is a better answer.  I wouldn't know
without seeing the use-case.


(And I was joking about the teasing and the hints - it just seemed to make a
better story if I told it that way :-)

NeilBrown
