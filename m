From: manish honap <manish_honap_vit@yahoo.co.in>
Subject: Re: [PATCH 1/1] ext4, dio: Remove overflow for size >2G in aio-dio code.
Date: Wed, 23 May 2012 00:13:40 +0800 (SGT)
Message-ID: <1337703220.54007.YahooMailNeo@web192401.mail.sg3.yahoo.com>
References: <F9014F50-D1F6-4B64-8535-7452CC64B18A@qualexsystems.com> <1337500880.16053.YahooMailNeo@web192405.mail.sg3.yahoo.com> <CA+55aFwTN_uFXnoLo=uJnA21FeUs_92c8FvMY6-aXk=UmF1zgQ@mail.gmail.com> <1337570918.78986.YahooMailNeo@web192406.mail.sg3.yahoo.com> <CA+55aFxA0Do37AxoM2MPH5nnMa2VAPHp1pKJ7CiafGGQL-b0wQ@mail.gmail.com> <CA+55aFyGJTJh3jddXdapQiC4ou=sS9PFMcX_qVUGa5qBjUZjDg@mail.gmail.com> <20120521233133.GG12339@thunk.org>
Reply-To: manish honap <manish_honap_vit@yahoo.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120521233133.GG12339@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Linus, Ted



On Mon, May 21, 2012 at 03:22:28PM -0700, Linus Torvalds wrote:
> 
> So I'm pretty sure this patch is what we want, and rw_verify_area()
> really is required to protect low-level filesystems from these kinds
> of issues. Not just ext4.

Patch works on my machine also. 
> 
> At the same time, I would *really* want somebody who actually uses
> anything AIO to test it out too. Because I want to not only commit it,
> but also mark it for stable - and it would be nice to have some more
> testing than me saying "ok, it passes the one test-case sent to me"
> and "hey, the code looks sane".

Used Chris Mason's aio-stress.c

- Manish

