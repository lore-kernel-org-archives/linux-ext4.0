From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 14:19:31 -0500
Message-ID: <20130227191931.GA14253@thunk.org>
References: <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185755.GA17786@redhat.com>
 <20130227190419.GB19624@thunk.org>
 <20130227191115.GA10710@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227191115.GA10710@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 02:11:15PM -0500, Dave Jones wrote:
> 
> fsck never found anything.  I do have another disk (XFS formatted) with
> a backup from a week ago. I'll run a --dry-run rsync to see if it
> picks up any changes that I don't expect.

Probably a good idea.

Given that Markus reports that this fixes the problem for him, and
regression smoke test has passed, I'll get a cleaned up patch ready
for Linus to pull ASAP.

My deep apologies that we didn't catch this earlier.  i'm going to
think about how we can improve our testing regime to make sure
problems like this get caught earlier.

				- Ted
