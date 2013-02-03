From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member into
 extent status tree
Date: Sun, 3 Feb 2013 11:19:43 +0300
Message-ID: <20130203081943.GF4937@mwanda>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
 <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
 <20130129030353.GK7003@thunk.org>
 <20130129053415.GA27002@gmail.com>
 <20130129172814.GC4261@thunk.org>
 <20130130024332.GA12111@gmail.com>
 <20130203030343.GB1359@thunk.org>
 <20130203052113.GA9823@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Christopher Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org
Return-path: <linux-sparse-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130203052113.GA9823@gmail.com>
Sender: linux-sparse-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Feb 03, 2013 at 01:21:13PM +0800, Zheng Liu wrote:
> On Sat, Feb 02, 2013 at 10:03:43PM -0500, Theodore Ts'o wrote:
> > On Wed, Jan 30, 2013 at 10:43:33AM +0800, Zheng Liu wrote:
> > > 
> > > Clang is first coming in my mind.  I know that some one try to use it
> > > to build a linux kernel and get a lot of problems that are about gcc
> > > extension.  But for us it seems that things are not too bad. ;)
> > 
> > Clang accepts bitfields with "unsigned long long", but I've discovered
> > something which does _not_ support unsigned long long --- the "sparse"
> > tool.  :-(
> 
> Yes, this problem has been reported by Fengguang.  So I am plan to use
> another method to define extent_status structure as last time we
> discuessed.  What do you think?
> 

I don't get this warning on my version of Sparse.

Sparse used to assume -m32 all the time but now that's been changed.
Are you using the most recent version of Sparse?  Try passing -m64.

regards,
dan carpenter

