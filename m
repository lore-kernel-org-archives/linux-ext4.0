From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: better error handling of kstrdup()
Date: Fri, 3 Apr 2015 00:25:16 -0400
Message-ID: <20150403042516.GA9988@thunk.org>
References: <1426886514-23522-1-git-send-email-tsgatesv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
	csong84@gatech.edu
To: Taesoo Kim <tsgatesv@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426886514-23522-1-git-send-email-tsgatesv@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 20, 2015 at 05:21:54PM -0400, Taesoo Kim wrote:
> Upon memory pressure, kstrdup() might fail and correctly
> handle memory error, although current implementation do not
> refer orig_data.
> 
> NOTE. fortunately the correct impl works, other than a
> corner case where kstrdup() fails and kzalloc() succeeds;
> it might record 'NULL' in the log.
> 
> Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>

Applied, thanks.

					- Ted
