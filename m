From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Mon, 17 Jun 2013 14:12:10 -0700
Message-ID: <51BF7BAA.5030803@intel.com>
References: <51B7B128.60909@intel.com> <20130614140940.GA20401@gmail.com> <20130614140215.GA1017@thunk.org> <20130614170028.GA21544@gmail.com> <20130614180054.GB1017@thunk.org> <20130617101033.GA17828@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130617101033.GA17828@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/17/2013 03:10 AM, Zheng Liu wrote:
> Dave, that would be great if you could do your testing again to confirm
> this patch is useful.

I was able to apply this to Ted's

	https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/

"ext4/dev" tree with a bit of fuzz.  What did you generate this against,
btw?

It does seem to be functioning OK for me, and passes the other tests
that saw so much spinlock contention previously.  You can add my
Tested-by if you like.
