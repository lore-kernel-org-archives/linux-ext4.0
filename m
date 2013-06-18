From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 extent status tree LRU locking
Date: Mon, 17 Jun 2013 22:51:34 -0400
Message-ID: <20130618025133.GB24479@thunk.org>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
 <20130614180054.GB1017@thunk.org>
 <20130617101033.GA17828@gmail.com>
 <51BF7BAA.5030803@intel.com>
 <20130618022548.GA24671@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130618022548.GA24671@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 18, 2013 at 10:25:48AM +0800, Zheng Liu wrote:
> Ah, sorry, I forgot to mention that this patch bases against ext4/master
> branch.  Now ext4/dev branch has some regression when I run xfstests.

What regressions are you seeing?

> Ted, I notice that now in ext4 tree we have 'dev', 'dev-with-revert',
> and 'dev2' branches.  Which one is the best to generate a new patch for
> the next merge window?

Either the dev branch or the master branch.   

The dev-with-revert and dev2 were branches that I had created when
investigating a potential regression with the invalidage page range
patch set.  I've since determined that it's a timing issue and it's
not a new regression --- we've had xfstests failures with test
generic/300 for a while now.

					- Ted
