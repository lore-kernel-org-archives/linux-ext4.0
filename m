From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Thu, 28 Feb 2013 03:27:05 +0800
Message-ID: <512E5E09.1040605@gmail.com>
References: <20130227153435.GB5609@thunk.org> <20130227154450.GA23402@x4> <20130227170157.GA222@x4> <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com> <20130227172256.GA236@x4> <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com> <20130227174553.GA224@x4> <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com> <20130227184912.GA19624@thunk.org> <20130227185625.GA224@x4> <20130227191923.GA1121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130227191923.GA1121@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/28/2013 03:19 AM, Dave Jones wrote:
> On Wed, Feb 27, 2013 at 07:56:25PM +0100, Markus Trippelsdorf wrote:
>  > On 2013.02.27 at 13:49 -0500, Theodore Ts'o wrote:
>  > 
>  > > Markus, Dave, can you confirm that this fixes your problem?
>  > 
>  > Yes, it fixes the issue.
> 
> Looks like it's fixed here too.
> 
> How did this make it through -next without anyone hitting it ?

Sorry, my apology.

> 
> I can't remember how many years ago I last bought a disk < 1TB,
> and I can't be alone.  Or is everyone all about SSDs these days?

I admit that I run xfstests on a SSD that has 128G.

> 
> Is anyone running xfstests or similar on linux-next regularly ?

Ted has a dev branch for -next, and I work on this branch.

Regards,
						- Zheng
