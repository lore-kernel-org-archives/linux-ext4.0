From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 18:49:49 -0400
Message-ID: <20110513224949.GB21165@thunk.org>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
 <20110513145608.GA21165@thunk.org>
 <4DCD4D5E.6050307@redhat.com>
 <BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 13, 2011 at 08:25:02PM +0300, Amir Goldstein wrote:
> 
> After xfstests failed to build on Ubuntu 10.10, I followed the
> advice omitted by the build script to run "make install-qa", to
> solve the problem.  It took me a while to figure exactly where I
> should run the command, but in the end I pulled the xfsprogs tree,
> ran "make; make install; make install-qa" and from there on things
> were looking better.

I did that, but fsstress doesn't pull in the needed xfs/xfs_fs.h
header file.  So it still dies.

						- Ted
