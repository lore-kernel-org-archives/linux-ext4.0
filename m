From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Tue, 18 Jun 2013 10:25:48 +0800
Message-ID: <20130618022548.GA24671@gmail.com>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
 <20130614180054.GB1017@thunk.org>
 <20130617101033.GA17828@gmail.com>
 <51BF7BAA.5030803@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan kara <jack@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51BF7BAA.5030803@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 17, 2013 at 02:12:10PM -0700, Dave Hansen wrote:
> On 06/17/2013 03:10 AM, Zheng Liu wrote:
> > Dave, that would be great if you could do your testing again to confirm
> > this patch is useful.
> 
> I was able to apply this to Ted's
> 
> 	https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/
> 
> "ext4/dev" tree with a bit of fuzz.  What did you generate this against,
> btw?

Ah, sorry, I forgot to mention that this patch bases against ext4/master
branch.  Now ext4/dev branch has some regression when I run xfstests.
So I don't base against this branch to generate my patch.

Ted, I notice that now in ext4 tree we have 'dev', 'dev-with-revert',
and 'dev2' branches.  Which one is the best to generate a new patch for
the next merge window?

> 
> It does seem to be functioning OK for me, and passes the other tests
> that saw so much spinlock contention previously.  You can add my
> Tested-by if you like.

Thanks for your testing.

Regards,
                                                - Zheng
