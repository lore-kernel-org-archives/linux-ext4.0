From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 16 Jan 2012 10:55:55 -0800
Message-ID: <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com> <20120116160136.GC16431@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120116160136.GC16431@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 16, 2012 at 8:01 AM, Jan Kara <jack@suse.cz> wrote:
>
> =A0Hum, let me understand this. I understand the meaning of buffer_up=
todate
> bit as "the buffer has at least as new content as what is on disk". N=
ow
> when storage cannot write the block under the buffer, the contents of=
 the
> buffer is still "at least as new as what is (was) on disk".

No.

Stop making crap up.

If the write fails, the buffer contents have *nothing* to do with what
is on disk.

You don't know what the disk contents are.

So clearly the buffer cannot be up-to-date.

Now, feel free to use *other* arguments for why we shouldn't clear the
up-to-date bit, but using the disk contents as one is pure and utter
garbage. And it is *obviously* pure and utter garbage.

                   Linus
