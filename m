From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 16:43:43 -0400
Message-ID: <20180720204343.GC27862@thunk.org>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
 <20180720131206.GM30706@thunk.org>
 <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
 <20180720145235.GA27862@thunk.org>
 <cd31ba58ac24851698e06628ceebce4648345ff6.camel@darmarit.de>
 <20180720164421.GG4800@magnolia>
 <93aa59853a491a5ba3d5c3bcc0c991a1b815a67d.camel@darmarit.de>
 <20180720171020.GI4800@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180720171020.GI4800@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2018 at 10:10:20AM -0700, Darrick J. Wong wrote:
> 
> Well yes, but it's the virtualenv workflow that produced build errors
> for Ted; that's what would seem to need fixing?

What would delight me if there was a fixed docutils and Sphinx version
which is the **only** thing which subsystem maintainers need to test
against.  If it fails for that version, then I reject the patch; and
if it works on that version (say, 1.4.9), and it fails on some other
version that a Distro wants to use for its hermetic build environment
(say, 1.7.5), I can tell them, "not my problem, feel free to send me a
patch that makes things work for 1.7.5, and doesn't break on 1.4.9 ---
or package 1.4.9 for your distro build systems."

I don't really care what the mandated version is --- although given
that Fedora and Debian seem to be using 1.7.5, maybe that's the right
answer, and too bad for the enterprise distro build systems --- that's
why they get paid the big bucks.  I just want to know what I'm obliged
to test against.

So if Documentation/sphinx/requirements.txt is the only thing which is
guaranteed to work, that's fine.  But it might be good to document
that somewhere.

						- Ted
