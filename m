From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member
	into extent status tree
Date: Sun, 3 Feb 2013 08:30:13 +0100
Message-ID: <20130203073013.GA25947@merkur.ravnborg.org>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com> <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com> <20130129030353.GK7003@thunk.org> <20130129053415.GA27002@gmail.com> <20130129172814.GC4261@thunk.org> <20130130024332.GA12111@gmail.com> <20130203030343.GB1359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Christopher Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-sparse-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130203030343.GB1359@thunk.org>
Sender: linux-sparse-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 02, 2013 at 10:03:43PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 30, 2013 at 10:43:33AM +0800, Zheng Liu wrote:
> > 
> > Clang is first coming in my mind.  I know that some one try to use it
> > to build a linux kernel and get a lot of problems that are about gcc
> > extension.  But for us it seems that things are not too bad. ;)
> 
> Clang accepts bitfields with "unsigned long long", but I've discovered
> something which does _not_ support unsigned long long --- the "sparse"
> tool.  :-(
> 
> I discovered this when running "make C=1", i.e.:
> 
>   rm -f fs/ext4/extents_status.o
>   make C=1 fs/ext4/extents_status.o

Small hint...
If you use:

    make C=2 fs/ext4/extents_status.o

Then kbuild will run sparse on all targets you specify,
even if they do not need to be rebuild.
In other words - you then do not need to delete the .o file first.

This works for all the usual ways you can specify a target so to
check all of ext4 you just issue:

    make C=2 fs/ext4/

	Sam
