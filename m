From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 23 Jan 2012 15:49:39 -0800
Message-ID: <CA+55aFxggjW6FKhf7KSCRMD-4YF9ymsxDQ+EMtUTThX16r-8tw@mail.gmail.com>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard> <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard> <20120123214709.GB17974@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120123214709.GB17974@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 23, 2012 at 1:47 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
> So how does XFS decide whether a write should fail and shutdown the
> file system, or just "try forever"?

Why would it bother? XFS tends to be a filesystem that you'd only use
for core files in environments where you have a system manager that
knows what he is doing. So there, maybe "try forever" is the right
thing to do.

Things are a bit different with some random unreliable USB stick FAT32
filesystem that just died on you, with a normal user that just removes
the thing or doesn't even notice that the stick is now dead. There the
"try forever" is totally the wrong thing to do.

                            Linus
