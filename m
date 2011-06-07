From: Allison Henderson <achender@vnet.ibm.com>
Subject: Re: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
Date: Mon, 06 Jun 2011 18:41:21 -0700
Message-ID: <4DED81C1.6000204@vnet.ibm.com>
References: <4DED63D1.5010600@vnet.ibm.com> <20110607004445.GG20818@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110607004445.GG20818@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/06/2011 05:44 PM, Ted Ts'o wrote:
> Hey Allison, there are two things you can do that will make life much
> easier for people to review and apply your patches.  First of all,
> move the version information below to after the "---" line.  If you
> want to keep this information in the git commit log, just move the
> "---" line after you run the "git format-patch" command.
>
> Secondly, run the command "git config format.thread true"; this is the
> default in newer versions of git, but apparently you're not using a
> new enough version of git.  You can also use "git send-email --thread"
> if you don't want to set the git configuration variable.  The other
> possibility is that your mailer is stripping the in-reply-to: and
> references: header, so the mail threading is disappearing.  I never
> used vnet.ibm.com's mailer, so I don't know if it's responsible for
> stripping mail headers, but I tend not to trust VM or Lotus Notes'
> standard adherence... fortunately for IBM the CIO's who make the
> purchasing decisions tend not to know the first thing about Internet
> Mail Standers or RFC's.:-)
>
> 		       	      	- Ted


Thx Ted!  I didn't realize the patches were hard for people to read.  I 
will see if I can get those commands to work, and I will make sure the 
"---" comes before the version info.  Initially I had tried the 
send-email, but not all of the patches seemed to make it to the lists, 
so I started using Thunderbird, but I will see if I can figure out what 
went wrong with send-email.  Thx!

Allison Henderson

