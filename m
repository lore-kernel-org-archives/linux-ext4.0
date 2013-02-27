From: Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 20:06:23 +0100
Message-ID: <20130227190623.GH5530@pd.tnic>
References: <20130227124727.GA225@x4>
 <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Dave Jones <davej@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227184912.GA19624@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 01:49:12PM -0500, Theodore Ts'o wrote:
> -#define EXTENT_STATUS_WRITTEN	0x80000000	/* written extent */
> -#define EXTENT_STATUS_UNWRITTEN	0x40000000	/* unwritten extent */
> -#define EXTENT_STATUS_DELAYED	0x20000000	/* delayed extent */
> -#define EXTENT_STATUS_HOLE	0x10000000	/* hole */
> +#define EXTENT_STATUS_WRITTEN	(((unsigned long long) 1) << 63)
> +#define EXTENT_STATUS_UNWRITTEN	(((unsigned long long) 1) << 62)
> +#define EXTENT_STATUS_DELAYED	(((unsigned long long) 1) << 61)
> +#define EXTENT_STATUS_HOLE	(((unsigned long long) 1) << 60)

Just a nitpick:

1ULL << ...

is shorter and probably the standard way we do flags.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
