From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Thu, 13 Jan 2011 22:12:20 +1100
Message-ID: <1294917140.2781.5.camel@shrek.rexursive.com>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
	 <20110112162655.GA13496@thunk.org>
	 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
	 <20110112172646.GB13496@thunk.org>
	 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
	 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
	pm list <linux-pm@lists.linux-foundation.org>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2011-01-12 at 19:44 -0500, Theodore Tso wrote:
> It looks like somehow the pages were left marked as dirty, so the
> writeback daemons attempted writing back a page to an inode which was
> never opened read/write (and in fact as a text page
> for /usr/bin/killall, was mapped read/only).

Just out of curiosity, when this happens, is LZO compression being used
with hibernation (default in 2.6.37) or has it been disabled?

-- 
Bojan
