From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 lockdep splat with v4.9-rc1
Date: Fri, 21 Oct 2016 12:05:25 +0200
Message-ID: <20161021100525.GA28926@quack2.suse.cz>
References: <20161021020616.GA25426@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021020616.GA25426@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 20-10-16 20:06:16, Ross Zwisler wrote:
> In my DAX PMD regression testing I hit the lockdep splat at the end of this
> mail.  I've tried to reproduce it multiple times, but haven't been able to.
> I'm hoping that the lockdep splat contains enough information by itself to be
> useful.
> 
> This testing was done with v8 of my DAX PMD series, but I don't think my
> series modifies any of the locks in the splat so I think the problem should
> exist with v4.9-rc1 as well.

Thanks for report. Yes, I'm aware of the problem and it started happening
after update of lockdep instrumentation in the fs freezing code. I didn't
get to fixing it yet.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
