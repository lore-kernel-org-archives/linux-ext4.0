From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Wed, 2 Sep 2015 17:52:01 +0100
Message-ID: <20150902165201.GW12432@techsingularity.net>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 31, 2015 at 02:37:38PM -0700, Linus Torvalds wrote:
> On Sun, Aug 30, 2015 at 11:19 PM, Jan Kara <jack@suse.cz> wrote:
> >
> > The biggest change in the pull is the removal of ext3 filesystem driver
> > (~28k lines removed).
> 
> I really am not ready to just remove ext3 without a lot of good
> arguments. There might well be people who this use ext3 as ext3, and
> don't want to update. I want more a rationale for removal than "ext4
> can read old ext3 filesystems".
> 

This is not my area at all but as Jan said he was out on vacation and
offline so there is no chance for him to adjust the tree before the window
closes. I'm going going to try and guess what justifications he might have
used if he was online.

1. Backwards compatibility -- other knowledgeable people, particularly
   Ted, already pointed out that backwards compatibility is guaranteed.
   I know SLE is using the ext4 driver for ext3 filesystems and AFAIK,
   there has been no bugs related to distro upgrades that failed to mount
   an ext3 filesystem with the ext4 driver. As other distributions made
   a similar decision and there is a lack of bug reports, there is some
   evidence that the guarantee is adhered to


2. ext4 driver performance -- when SLE considered switching to the ext4
   driver, I successfully checked that the ext4 driver matched or exceeded
   the performance of the ext3 driver. Granted, this was limited in terms
   of types of storage but as other distros are also using ext4 driver,
   I'm guessing that no one found regressions. I don't have the data any
   more but I don't recall a single instance where the ext3 driver was better

2. ext3-specific hack removals in block and VM. The merge request stated
   that some workarounds in the VM and block layer could be got rid of but
   I don't have a comprehensive list. Glancing at the branch though, at
   least one hack is removed with "block: Remove forced page bouncing under
   IO". I did not investigate deeply but it looks like cancel_dirty_page
   is another potential candidate for going away.

3. Missing fixes. Fixes applied to ext4 have to be manually back-ported
   to ext3, mostly by Jan, but it's possible one will be missed and ext3
   slowly bit rots. Ted already said this a lot better than I did so I'll
   just repeat it

	Both Red Hat and SuSE, as well as Debian and Ubuntu, are using
	ext4 with CONFIG_EXT4_USE_FOR_EXT23 for a couple of years now
	to support ext2 and ext3 file systems.	So with the exception of
	some really ancient enterprise Linux distros, and people who are
	manually configuring their systems, very few people are likely using
	ext3 code base, which means the chances that it bitrots increases.
	Basically, it's only been Jan's tireless work that has kept that
	from happening, given that all of the major distro's have been
	using ext4 to support ext2 and ext3 file systems.

On the flip side, there does not appear to be any good reason for
keeping the ext3 driver around because if there ever is a case where an
old kernel is required to mount an ext3 filesystem then it appears the
ext4 developers would consider it a bug.

-- 
Mel Gorman
SUSE Labs
