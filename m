From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove static from struct match_token used in
 token2str
Date: Sun, 23 Sep 2012 22:59:35 -0400
Message-ID: <20120924025935.GA27627@thunk.org>
References: <1348276860-21705-1-git-send-email-herton.krzesinski@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348276860-21705-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 21, 2012 at 10:21:00PM -0300, Herton Ronaldo Krzesinski wrote:
> There is no reason to use static there, and it will cause issues when
> reading /proc/fs/ext4/<partition>/options concurrently.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Cc: stable@vger.kernel.org # 3.4+

Herton,

Thanks for finding the bug fix!  I changed the commit descipription
slightly and have applied your patch to the ext4 tree.

	     	  	       	     	    - Ted

ext4: fix crash when accessing /proc/mounts concurrently

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

The crash was caused by a variable being erronously declared static in
token2str().

In addition to /proc/mounts, the problem can also be easily replicated
by accessing /proc/fs/ext4/<partition>/options in parallel:

$ cat /proc/fs/ext4/<partition>/options > options.txt

... and then running the following command in two different terminals:

$ while diff /proc/fs/ext4/<partition>/options options.txt; do true; done

This is also the cause of the following a crash while running xfstests
#234, as reported in the following bug reports:

	https://bugs.launchpad.net/bugs/1053019
	https://bugzilla.kernel.org/show_bug.cgi?id=47731

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Brad Figg <brad.figg@canonical.com>
Cc: stable@vger.kernel.org
