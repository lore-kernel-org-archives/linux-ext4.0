From: Taesoo Kim <taesoo@gatech.edu>
Subject: Re: [PATCH 1/1] ext4: better error handling of kstrdup()
Date: Fri, 3 Apr 2015 13:44:20 -0400
Message-ID: <20150403174420.GY28537@taesoo.org>
References: <1426886514-23522-1-git-send-email-tsgatesv@gmail.com>
 <20150403050943.GB9988@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Taesoo Kim <tsgatesv@gmail.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, changwoo@gatech.edu,
	sanidhya@gatech.edu, blee@gatech.edu, csong84@gatech.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150403050943.GB9988@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

It's my fault. I didn't properly check the case of having data = NULL
to kstrdup() as my system has long mounting options.. Sorry for the
trouble. I think there is no clean way to handle this error (better),
other than implicitly letting kstrdup() fail (and ignore).

Taesoo

On 04/03/15 at 01:09am, Theodore Ts'o wrote:
> On Fri, Mar 20, 2015 at 05:21:54PM -0400, Taesoo Kim wrote:
> > Upon memory pressure, kstrdup() might fail and correctly
> > handle memory error, although current implementation do not
> > refer orig_data.
> > 
> > NOTE. fortunately the correct impl works, other than a
> > corner case where kstrdup() fails and kzalloc() succeeds;
> > it might record 'NULL' in the log.
> > 
> > Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
> 
> Did you test this patch?  If there are no mount options (such as when
> mounting the root file system, data is NULL, so orig_data is NULL),
> and the mount fails.  So a kernel won't boot with this patch applied.
> 
> 					- Ted
