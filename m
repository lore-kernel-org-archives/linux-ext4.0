From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Sun, 10 Apr 2016 13:48:39 -0700
Message-ID: <CA+55aFzfmHptveL=y1C5VidQjjiSekcCq=-fg1Z-W6Szog-VRA@mail.gmail.com>
References: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
	<CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Greg Thelen <gthelen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 10, 2016 at 1:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think the right choice might be to
>
>  (a) revert that patch (or just change the signal_pending() into
> fatal_signal_pending())
>
>  (b) to get the latency advantage, do something like this:

The attached patch is actually tested and seems to fix the issue.

I do not have a good way to check the latency of signal delivery and I
didn't check if the signal_pending() actually ever triggers, but your
test-case that showed the problem before seems to be fine with it.

                     Linus
