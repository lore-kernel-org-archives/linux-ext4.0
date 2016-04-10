From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Sun, 10 Apr 2016 13:36:14 -0700
Message-ID: <CA+55aFz5UHYVWbFHzmudxNMTMrZQ8+rQPyUNPhjxX4nphW2yVA@mail.gmail.com>
References: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
	<CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
	<CA+55aFxzp-A_E5twKqbOFYgLZH8O7Z0wW3nCAg_U9KWNgHFAXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Greg Thelen <gthelen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxzp-A_E5twKqbOFYgLZH8O7Z0wW3nCAg_U9KWNgHFAXQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 10, 2016 at 1:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>      if (signal_pending())
>         return -EINTR;

"signal_pending(current)", dammit.

I give up. I'm sure you understood what I meant. I need to go make
myself more coffee. Or something.

               Linus
