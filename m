From: Andi Kleen <andi@firstfloor.org>
Subject: Re: GIT PULL] ext4 updates for 3.4
Date: Fri, 30 Mar 2012 13:54:17 -0700
Message-ID: <m2y5qhyfly.fsf@firstfloor.org>
References: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com>
	<CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 28 Mar 2012 16:36:23 -0700")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Mar 26, 2012 at 11:07 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> Ext4 commits for 3.3 merge window; mostly cleanups and bug fixes
>
> Ted, is there any chance that the dirty handling (or something else)
> has some serious latency bug?

There's at least a serious scalability bug. That new extent cache 
statistic count in the super block is showing up badly on IO profiles
on larger systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
