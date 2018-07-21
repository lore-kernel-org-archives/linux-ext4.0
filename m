From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Sphinx version dependencies?
Date: Sat, 21 Jul 2018 04:38:47 -0600
Message-ID: <20180721043847.59a2cb0a@lwn.net>
References: <20180719181556.GA21435@thunk.org>
        <20180719190400.GB4800@magnolia>
        <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
        <20180720131206.GM30706@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720131206.GM30706@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 20 Jul 2018 09:12:06 -0400
"Theodore Y. Ts'o" <tytso@mit.edu> wrote:

> A forth solution is to force everyone to use something correleted to
> what the community distro's are packaging, but roughly every 12-18
> months, we leapfrog to a newer version of Sphinx.  This decreases the
> continuous upgrade burden, but doesn't make it go away.

[I'm mostly AFK at the moment, so haven't been following this discussion
in anything approaching real time].

The above is roughly what I've been aiming for; I'd really like for
people to be able to just build the docs without having to go beyond
their distribution's repos.  It gets challenging at times because Kids
These Days seem to have a different view on issues like long-term
compatibility.  But we've mostly done it; it's pretty rare that we've had
docs build problems that have been tied to a specific version of Sphinx.

You all just got lucky :)

jon
