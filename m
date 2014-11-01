From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 3.18
Date: Sat, 1 Nov 2014 09:29:14 -0700
Message-ID: <CA+55aFz=Dv=FuVD=WDMjOAi-eG2ZbHT5F7Gc78BpMrVDZKpQnQ@mail.gmail.com>
References: <20141031214949.GA644@thunk.org>
	<CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
	<20141101133802.GA31245@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141101133802.GA31245@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 1, 2014 at 6:38 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> I didn't think hash_64 was *that* slow, so it's not clear the above
> would be faster, though.  And if someone is using a > 16TB file system
> on a 32-bit platform, I suspect they might be having other problems.  :-)

Fair enough, hash_64() isn't *that* slow. But it _is_ 6 64-bit shifts
and adds/subtracts, which on a 32-bit machine tends to be quite
expensive. On some of them it's function calls etc.

And your point about >16TB filesystems is completely buggy. That was
*my* point. Most people - even on 64-bit - do *not* have 16TB
filesystems, and the high 32 bits are zero or contain very very little
information (ie even on a multi-terabyte filesystem, it's one or two
bits worth of information). So hash_32() is not only much more
reasonable on a 32-bit machine, the end result is basically as good
for 99.999% of all uses. Exactly *because* people don't have those big
filesystems.

               Linus
