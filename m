From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v2] jbd2: fix sphinx kerel-doc build warnings
Date: Wed, 10 Jan 2018 17:29:30 +1100
Message-ID: <20180110062930.GA25272@eros>
References: <1515548549-25866-1-git-send-email-me@tobin.cc>
 <20180110052619.GG5809@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110052619.GG5809@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 10, 2018 at 12:26:19AM -0500, Theodore Ts'o wrote:
> On Wed, Jan 10, 2018 at 12:42:29PM +1100, Tobin C. Harding wrote:
> > Sphinx emits various (26) warnings when building make target 'htmldocs'.
> > Currently struct definitions contain duplicate documentation, some as
> > kernel-docs and some as standard c89 comments.  We can reduce
> > duplication while cleaning up the kernel docs.
> > 
> > Move all kernel-docs to right above each struct member.  Use the set of
> > all existing comments (kernel-doc and c89).  Add documentation for
> > missing struct members and function arguments.
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> 
> Thanks, applied.  I did fix up a few of your newly added doc strings.
> 
> 		    	       - Ted

Oh cool, thanks.

	Tobin
