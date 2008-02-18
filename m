From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 13:57:02 +0100
Message-ID: <20080218125702.GB15044@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760308AbYBRM56@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080218114936.GM8905@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Theodore Tso <tytso@MIT.EDU> wrote:

> I'm going to NACK it as well.  This kind of code churn where we make 
> symbols static only to make them non-static again in an existing ext4 
> tree is exactly the sort of needless code churn that makes patches 
> start to conflict and where we need different patches depending on 
> whether it is intended for -mm or linux-next or mainline.

Resolving a reject due to a line of code difference is about 10 seconds 
of your or time - and you two already spent 10-100 times more time on 
just fighting that line of code - which is weird. Yes, "naked" exports 
are sometimes OK (and i recently defended and NACK-ed an export removal 
in one such case), but the reason given here, out of tree forks are very 
much not such a case.

Example: recently i got some scheduler stuff not included in time - and 
had to remove an unnecessary export. Stupid me for not having planned it 
right and i deserved looking stupid in the git log. This time you did 
not get the "journal checksum patch" into 2.6.25 by time: tough luck, it 
shows that you suck at getting stuff done in time sometimes.

So please deal with it like most other subsystem maintainers do and stop 
complaining about "code churn" - nobody but you changes the ext3 
codebase, it's one of the codebases least affected by general kernel 
flux, it's an ultimate "leaf" subsystem.

In fact, we only had 5300 lines of code flux in ext3 in the past ~3 
years:

  $ git-log -p -M v2.6.12.. fs/ext3/ | diffstat | tail -1
    45 files changed, 3205 insertions(+), 2043 deletions(-)

with its 16 KLOC's that's a churn rate of ~10% per year. [and 9% out of 
that was ext3's own feature churn, nothing externally inflicted]

As a comparison, the core kernel had a churn of 182,000 lines [and this 
excludes renames] in the past 3 years:

  $ git-log -p -M v2.6.12.. kernel/ | diffstat | tail -1
    284 files changed, 96256 insertions(+), 45277 deletions(-)

and with it being a 91 KLOC codebase that's a _51%_ churn rate per year.

Or take a look at the networking code, with a ~40% 3-year churn rate in 
half a million lines of code. _That_ is a high rate of change - but the 
networking people have learned how to deal with it and Linux has become 
the best OS on the planet in terms of networking technology.

The whole kernel has 8406491 LOC at the moment, in the past 3 years it 
had a churn of 9214017 lines of code (excluding renames), which averages 
to a churn rate of ~35% per year.

	Ingo
