From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4, quota, projectid:  limits without capablity
Date: Fri, 5 Jan 2018 14:20:20 -0500
Message-ID: <20180105192020.GB8287@thunk.org>
References: <c18ff577-be92-40ea-93ae-4401ce2107da.yuanliang.wyl@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "adilger.kernel" <adilger.kernel@dilger.ca>,
        pkuelelixi <pkuelelixi@gmail.com>, jack <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
To: =?utf-8?B?546L5YWD6Imv?= <yuanliang.wyl@alibaba-inc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c18ff577-be92-40ea-93ae-4401ce2107da.yuanliang.wyl@alibaba-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 05, 2018 at 03:23:43PM +0800, 王元良 wrote:
> 
> hi,  all
> We use projectid for space restrictions inside the container, share the same hard link between the host and multiple containers.
> But I encountered a problem, as follows, are the following modifications feasible ?

I'm not sure what the problem that you encoutered.  So it's hard to
judge the modification, especially since you didn't send it in a
proper unified diff format.

It looks like you are trying to allow root to avoid the restriction an
entire directory hierarchy (all files and subdirectories) must have
the same project ID.  There are a couple of problems with this.  For
example, you only do this for the link case, but we enforce the same
restriction in other places, such as the rename case.

The current restrictions are to make life simpler for users.  The
restrictions are also part of the xfstests regression test, so I'm
fairly certain will cause a test failure.

So this is something I wouldn't want to do without general agreement
across all of the file systems developers, since it breaks the
fundamental model of how project IDs are presented to users, and could
end up making things extremely confusing.  So the best way to do this
is for you to give much more details about why you want this change,
and what is the larger context of what is you are trying to do.

    	    	       	       	  - Ted
