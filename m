From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
Date: Mon, 6 Jun 2011 20:44:45 -0400
Message-ID: <20110607004445.GG20818@thunk.org>
References: <4DED63D1.5010600@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Allison Henderson <achender@vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DED63D1.5010600@vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 06, 2011 at 04:33:37PM -0700, Allison Henderson wrote:
> This patch adds punch hole tests to the fsx stress test. 
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> 

Hey Allison, there are two things you can do that will make life much
easier for people to review and apply your patches.  First of all,
move the version information below to after the "---" line.  If you
want to keep this information in the git commit log, just move the
"---" line after you run the "git format-patch" command.

Secondly, run the command "git config format.thread true"; this is the
default in newer versions of git, but apparently you're not using a
new enough version of git.  You can also use "git send-email --thread"
if you don't want to set the git configuration variable.  The other
possibility is that your mailer is stripping the in-reply-to: and
references: header, so the mail threading is disappearing.  I never
used vnet.ibm.com's mailer, so I don't know if it's responsible for
stripping mail headers, but I tend not to trust VM or Lotus Notes'
standard adherence... fortunately for IBM the CIO's who make the
purchasing decisions tend not to know the first thing about Internet
Mail Standers or RFC's.  :-)

		       	      	       - Ted

> v1 -> v2:
> Corrections to the Makefile have been backed out.
> This patch needs to be applied on top of
> the "xfstests: clean up fallocate configuration tests"
> patch
> 
> The punch hole tests can be disabled with the
> -H flag, and will also be disabled if it is
> detected that the filesystem does not support
> punch hole
> 
> v2 -> v4
> Punch hole tests and functionality tests have been moved
> into their own functions.  Existing dofallocate routine
> has been renamed to do_preallocate.
> 
> v4 -> v5
> The code to test fallocate functionality changed slightly,
> so the patch has been updated to apply with out err
> ---
> :100644 100644 0eebc70... 0683853... M	ltp/fsx.c
>  ltp/fsx.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 124 insertions(+), 19 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 0eebc70..0683853 100644
...
