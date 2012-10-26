From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Date: Fri, 26 Oct 2012 22:24:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20121026061206.GA31139@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com>
 <20121026184649.GA8614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966778Ab2JZWe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 18:34:28 -0400
In-Reply-To: <20121026184649.GA8614@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Well, we could set a new attribute bit on the file which indicates
> that the file has been corrupted, and this could cause any attempts to
> open the file to return some error until the bit has been cleared.

That sounds a lot better than renaming/moving the file.

> This would persist across reboots.  The only problem is that system
> administrators might get very confused (at least at first, when they
> first run a kernel or a distribution which has this feature enabled).

Yes. This would require some education. But new attributes have been
added in the past (e.g. immutable) that caused confusion to users and
tools that didn't know about them.

> Application programs could also get very confused when any attempt to
> open or read from a file suddenly returned some new error code (EIO,
> or should we designate a new errno code for this purpose, so there is
> a better indication of what the heck was going on?)

EIO sounds wrong ... but it is perhaps the best of the existing codes. Adding
a new one is also challenging too.

> Also, if we just log the message in dmesg, if the system administrator
> doesn't find the "this file is corrupted" bit right away

This is pretty much a given. Nobody will see the message in the console log
until it is far too late.

> I'm not sure it's worth it to go to these extents, but I could imagine
> some customers wanting to have this sort of information.  Do we know
> what their "nice to have" / "must have" requirements might be?

18 years ago Intel rather famously attempted to sell users on the idea that a
rare divide error that sometimes gave the wrong answer could be ignored. Before
my time at Intel, but it is still burned into the corporate psyche that customers
really don't like to get the wrong answers from their computers.

Whether it is worth it may depend on the relative frequency of data being
corrupted this way, compared to all the other ways that it might get messed
up. If it were a thousand times more likely that data got silently corrupted
on its path to media, sitting spinning on the media, and then back off the
drive again - then all this fancy stuff wouldn't make any real difference.
I have no data on the relative error rates of memory and i/o - so I can't
answer this.

-Tony
